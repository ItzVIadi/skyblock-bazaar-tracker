#!/bin/sh
# Git-Sync-Check: zeigt, ob dieses Projekt mit GitHub synchron ist und ob der Login steht.
# Manuell:  sh check-sync.sh
# Als SessionStart-Hook (Claude Code): sh check-sync.sh --hook   (siehe .claude/settings.json)
# Nur lesende Befehle (git fetch, git status, gh auth status) - aendert nichts am Projekt.

MODE="$1"
cd "$(dirname "$0")" 2>/dev/null || exit 0

out=""
add() { out="${out}$1
"; }
problems=0
problem() { problems=$((problems + 1)); add "[!] $1"; }
ok() { add "[ok] $1"; }

if ! command -v git >/dev/null 2>&1; then
  add "git nicht gefunden - Check uebersprungen."
elif ! git rev-parse --git-dir >/dev/null 2>&1; then
  add "Kein Git-Repo - Check uebersprungen."
else
  BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  add "Projekt: $(basename "$(pwd)")  Branch: $BRANCH"

  if command -v gh >/dev/null 2>&1; then
    if gh auth status >/dev/null 2>&1; then
      ok "GitHub-Login (gh) steht."
    else
      problem "NICHT bei GitHub eingeloggt -> 'gh auth login' ausfuehren (auf neuem Geraet einmalig noetig)."
    fi
  else
    add "(gh CLI nicht installiert - ok, wenn nur ueber die Claude-Code-App/Cloud gearbeitet wird)"
  fi

  if ! git remote get-url origin >/dev/null 2>&1; then
    problem "Kein GitHub-Remote 'origin' - Projekt ist nicht gesichert/nicht von anderen Geraeten erreichbar."
  else
    if command -v timeout >/dev/null 2>&1; then
      timeout 15 git fetch origin --quiet 2>/dev/null
    else
      git fetch origin --quiet 2>/dev/null
    fi
    if [ $? -ne 0 ]; then
      problem "git fetch fehlgeschlagen (offline oder kein Zugriff/Login?) - Sync-Stand unbekannt."
    elif git rev-parse --verify --quiet "origin/$BRANCH" >/dev/null; then
      AHEAD=$(git rev-list --count "origin/$BRANCH..HEAD")
      BEHIND=$(git rev-list --count "HEAD..origin/$BRANCH")
      [ "$AHEAD" -gt 0 ] && problem "$AHEAD Commit(s) nur lokal -> 'git push' (sonst auf anderen Geraeten nicht sichtbar)."
      [ "$BEHIND" -gt 0 ] && problem "$BEHIND Commit(s) nur auf GitHub -> zuerst 'git pull' (sonst arbeitest du auf altem Stand)."
      [ "$AHEAD" -eq 0 ] && [ "$BEHIND" -eq 0 ] && ok "Synchron mit GitHub (origin/$BRANCH)."
    else
      problem "Branch '$BRANCH' existiert noch nicht auf GitHub -> 'git push -u origin $BRANCH'."
    fi
  fi

  CHANGED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  [ "$CHANGED" -gt 0 ] && problem "$CHANGED Datei(en) mit uncommitteten Aenderungen - vor Geraetewechsel committen + pushen."
fi

if [ "$problems" -eq 0 ]; then
  add "=> Alles in Ordnung."
else
  add "=> $problems Punkt(e) pruefen, bevor du das Geraet wechselst."
fi

if [ "$MODE" = "--hook" ]; then
  msg="Git-Sync-Check (automatisch beim Sessionstart):
${out}
Anweisung: Teile dem Nutzer dieses Ergebnis gleich am Anfang deiner ersten Antwort kurz mit (1-3 Zeilen, deutsch), besonders [!]-Punkte, und biete an, sie zu beheben (push/pull/commit). Wenn alles ok ist, genuegt ein kurzer Satz."
  esc=$(printf '%s' "$msg" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' | awk 'BEGIN{ORS="\\n"} {print}')
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}' "$esc"
else
  printf '%s' "$out"
fi
exit 0
