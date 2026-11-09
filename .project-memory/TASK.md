# Current task

Явное текущее состояние работы. Агент читает этот файл при старте и обновляет его по событиям, а не только в конце сессии. Длина активной части — компактная (~60 строк), старые записи живут в `SESSIONS.md`.

## Теперь (текущий статус)

status: idle

## Последняя задача (резюме)

- цель: полная самодостаточность папки .project-memory (ничего вне неё) + памятка для пользователя
- что сделано: `memory-autosave.sh` и `pre-commit` перенесены внутрь папки, `scripts/` и `.githooks/` удалены, все ссылания на пути обновлены, создана `.project-memory/README.md`
- статус: done
- следующий шаг: none — опубликовано: github.com/IgerOK/AllToAny (ожидает подтверждения пользователя). Опционально: активировать хук, починить secret-скан

## Open work (если status != idle)

- next step: none
- checks to run: `bash .project-memory/memory-check.sh`
- blockers: none
- decisions to reference: DECISIONS.md — 2026-11-09 «Self-contained .project-memory folder»

## Подпись последнего обновления

last-updated: 2026-11-09
