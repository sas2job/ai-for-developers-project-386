# Рабочие правила

- Запуск: `bundle install`, `npm ci`, `bin/rails db:prepare`, затем `bin/dev`.
- Все проверки: `bin/check`. Отдельно: `bin/rails test`, `bin/rubocop`, `npm run lint`, `npm run format:check`, `npm run build`.
- API: контракт в `api/main.tsp`; после его изменения запускайте `npm run api:generate` и сохраняйте `api/generated/openapi.yaml` вместе с `app/javascript/generated/src/`.
- Устройство: Rails-контроллеры и представления в `app/`, JavaScript-контроллеры Stimulus в `app/javascript/controllers/`, тесты Minitest в `test/`.
- Git-хук вызывает `bin/check`; включить его можно командой `git config core.hooksPath .githooks`.
- Коммиты оформляйте по Conventional Commits: `feat:`, `fix:`, `test:`, `docs:`, `chore:` и другие стандартные типы.

## Agent skills

### Issue tracker

При работе со спецификациями и тикетами используйте GitHub Issues этого репозитория. См. `docs/agents/issue-tracker.md`.

### Triage labels

При разборе задач используйте стандартные метки triage. См. `docs/agents/triage-labels.md`.

### Domain docs

Для предметной области используйте один `GLOSSARY.md` и решения в `docs/adr/`. См. `docs/agents/domain.md`.
