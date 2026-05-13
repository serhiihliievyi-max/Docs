---
tags: [carsharing, mvp, scope]
created: 2025-05-10
related: ["[[api-endpoints]]", "[[tech-decisions]]", "[[project-overview]]"]
---

# 🎯 MVP Scope — упрощённый вариант

> [!info] Цель MVP
> Показать core value продукта: **найти машину → забронировать → хозяин подтвердил**. Всё остальное — обвязка которую можно добавить в v2.

## Что входит в MVP

### Эндпоинты (20 штук)

**Auth — 4**
- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/logout`
- `POST /auth/refresh`

**Users — 3**
- `GET /users/me`
- `PATCH /users/me`
- `POST /users/me/avatar`

**Cars — 5**
- `GET /cars` (с фильтрами)
- `GET /cars/me`
- `GET /cars/:id`
- `POST /cars`
- `PATCH /cars/:id`

**Availability — 3**
- `GET /cars/:id/availability`
- `POST /cars/:id/availability`
- `DELETE /cars/:id/availability/:slotId`

**Bookings — 5**
- `POST /bookings`
- `GET /bookings/my`
- `GET /bookings/incoming`
- `PATCH /bookings/:id/confirm`
- `PATCH /bookings/:id/cancel`

---

## Что убрали и почему

| Что | Почему убрали | Когда вернуть |
|-----|--------------|---------------|
| Платёжка (Stripe) | Stripe требует вебхуки, тестовые карты, edge-cases. Заменяем `payment_method: cash` | v2 |
| Чат | Отдельный продукт внутри продукта. Телефон владельца виден после подтверждения брони | v2 |
| KYC верификация | Только загрузка файла. Флаг `is_blocked` проставляется вручную | v2 |
| Forgot/reset password | Некритично для демо | v2 |
| Отзывы на пользователя | Достаточно отзывов на машину | v2 |
| `DELETE /cars/:id` | Достаточно `PATCH` с `car_status: inactive` | — |
| Публичный профиль `/users/:id` | Имя и рейтинг показываются прямо в карточке авто | v2 |
| Payments модуль | Весь модуль отложен | v2 |

---

## Упрощения в реализации

### Оплата
```json
{
  "provider": "cash",
  "status": "pending"
}
```
Вместо интеграции со Stripe — просто запись в таблице payments с provider=cash. Деньги передаются при встрече.

### Блокировка
- Поле `is_blocked: boolean` в таблице users
- Проставляется вручную через Supabase Studio
- Никакой автоматической проверки документов или блокировки юзера

### Чат
- Поле `phone` в профиле пользователя
- Телефон владельца становится виден арендатору после того как бронь переходит в статус `CONFIRMED`

### Уведомления
- Email через Supabase Auth triggers (встроено)
- Никакого отдельного сервиса уведомлений

---

---

## Связанные страницы

- [[api-endpoints]] — полный список эндпоинтов
- [[project-overview]] — описание продукта
