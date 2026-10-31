# Календарь звонков


[![hexlet-check](https://github.com/sas2job/ai-for-developers-project-386/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/sas2job/ai-for-developers-project-386/actions)

Разработайте совместно с ИИ сервис для бронирования календаря

Учебный проект Хекслета: https://ru.hexlet.io/programs/ai-for-developers
Как это должно работать: https://files.hexlet.app/a/2ipc5m

## Сценарий записи

1. Владелец календаря открывает раздел управления и создаёт тип встречи: указывает название, описание и длительность.
2. Гость без регистрации открывает каталог типов встреч и выбирает подходящий тип.
3. Гость видит календарь на ближайшие 14 календарных дней, выбирает день и свободное время. Длительность слота равна длительности выбранного типа встречи.
4. Гость подтверждает запись. Занятый интервал больше не предлагается для других встреч, в том числе встреч другого типа.
5. Владелец видит новую запись в общем списке предстоящих встреч всех типов.

Приложение рассчитано на одного заранее заданного владельца. Авторизация, личные кабинеты, внешние календари и уведомления не входят в сценарий. Пересечение встреч, включая частичное, запрещено и при одновременных запросах; следующая встреча может начаться в момент окончания предыдущей. Точные часы работы, часовой пояс и шаг начала слотов будут зафиксированы в спецификации.


## Стек

- Ruby on Rails 8.1, Hotwire (Turbo и Stimulus), PostgreSQL
- JavaScript и esbuild для интерфейса
- TypeSpec → OpenAPI → JavaScript SDK для API
- Minitest, RuboCop, Oxlint и oxfmt для проверок

## Установка

Нужны PostgreSQL 18, Ruby 4.0.2 и Node.js 24.19.0. Версии Ruby и Node.js зафиксированы в `.ruby-version` и `.node-version`. Для локальной базы нужна роль PostgreSQL с правом создавать базы; подключение настраивается переменными `DB_HOST`, `DB_PORT`, `DB_USER` и `DB_PASSWORD`.

```bash
git clone https://github.com/sas2job/ai-for-developers-project-386.git
cd ai-for-developers-project-386
bundle install
npm ci
bin/rails db:prepare
git config core.hooksPath .githooks
```

## Использование

```bash
bin/dev       # сервер на http://localhost:3000 и сборка JavaScript с отслеживанием изменений
bin/check     # RuboCop, Oxlint, oxfmt, TypeSpec, сборка JavaScript и дымовой тест
```

После изменения `api/main.tsp` запустите `npm run api:generate` и сохраните обновлённые OpenAPI и SDK. API поддерживает проверку состояния, каталог типов встреч, поиск слотов и создание записи; гостевой интерфейс бронирования и список предстоящих встреч появятся на следующих шагах.

Docker-образ можно собрать и запустить так:

```bash
SECRET_KEY_BASE="$(bin/rails secret)" docker compose up --build
```

Контейнер приложения подключается к PostgreSQL из `compose.yaml`. Данные базы хранятся в Docker volume `postgres_data`; удалите его командой `docker compose down --volumes`.

---

<details>
<summary>Автоматические тесты Хекслета</summary>

Тесты запускаются на каждый коммит. За запуск отвечает файл `.github/workflows/hexlet-check.yml` — не удаляйте и не переименовывайте ни его, ни репозиторий.

</details>

## О Хекслете

[Хекслет](https://ru.hexlet.io/) — школа программирования: авторские программы обучения с практикой, поддержкой наставников и реальными проектами, которые остаются в резюме. Этот репозиторий — один из таких проектов.
