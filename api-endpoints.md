---
tags: [carsharing, backend, api, rest]
created: 2025-05-10
related: ["[[graphql-schema]]", "[[entities]]", "[[mvp-scope]]"]
---

# 🔌 API Эндпоинты (REST)

> [!info] Всего: 38 эндпоинтов · MVP: 26 · Отложить: 12

Базовый URL: `/api/v1`
Аутентификация: `Authorization: Bearer <access_token>`

---

## Сводная таблица

**Auth**

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|:---:|
| POST | `/auth/register` | Регистрация | ✓ |
| POST | `/auth/login` | Вход | ✓ |
| POST | `/auth/logout` | Выход | ✓ |
| POST | `/auth/refresh` | Обновление токена | ✓ |
| POST | `/auth/forgot-password` | Запрос сброса пароля | — |
| POST | `/auth/reset-password` | Установка нового пароля | — |

**Users**

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|:---:|
| GET | `/users/me` | Свой профиль | ✓ |
| PATCH | `/users/me` | Обновить профиль | ✓ |
| POST | `/users/me/avatar` | Загрузить аватар | ✓ |
| POST | `/users/me/documents` | Загрузить документ | — |
| GET | `/users/:id` | Публичный профиль | — |

**Cars**

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|:---:|
| GET | `/cars` | Поиск с фильтрами | ✓ |
| GET | `/cars/me` | Мои машины | ✓ |
| GET | `/cars/:id` | Детали машины | ✓ |
| POST | `/cars` | Создать машину | ✓ |
| PATCH | `/cars/:id` | Редактировать машину | ✓ |
| DELETE | `/cars/:id` | Деактивировать машину | — |
| POST | `/cars/:id/photos` | Добавить фото | — |
| DELETE | `/cars/:id/photos/:photoId` | Удалить фото | — |

**Slots**

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|:---:|
| GET | `/cars/:id/slots` | Календарь доступности | ✓ |
| POST | `/cars/:id/slots` | Добавить период | ✓ |
| DELETE | `/cars/:id/slots/:slotId` | Удалить период | ✓ |

**Bookings**

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|:---:|
| POST | `/bookings` | Создать заявку | ✓ |
| GET | `/bookings/my` | Мои брони (арендатор) | ✓ |
| GET | `/bookings/incoming` | Входящие (владелец) | ✓ |
| GET | `/bookings/:id` | Детали брони | ✓ |
| PATCH | `/bookings/:id/confirm` | Подтвердить | ✓ |
| PATCH | `/bookings/:id/cancel` | Отменить | ✓ |
| PATCH | `/bookings/:id/complete` | Завершить | — |

**Payments**

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|:---:|
| POST | `/payments/intent` | Создать PaymentIntent (Stripe) | — |
| POST | `/payments/webhook` | Вебхук от Stripe | — |
| GET | `/payments/history` | История платежей | — |

**Reviews**

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|:---:|
| POST | `/reviews` | Оставить отзыв | ✓ |
| GET | `/reviews/car/:carId` | Отзывы на машину | ✓ |
| GET | `/reviews/user/:userId` | Отзывы на пользователя | — |

**Messages**

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|:---:|
| GET | `/messages/:bookingId` | История чата | ✓ |
| POST | `/messages/:bookingId` | Отправить сообщение | ✓ |

---

## Auth

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|-----|
| POST | `/auth/register` | Регистрация нового пользователя | ✓ |
| POST | `/auth/login` | Вход по email + пароль | ✓ |
| POST | `/auth/logout` | Выход (инвалидация токена) | ✓ |
| POST | `/auth/refresh` | Обновление access token | ✓ |
| POST | `/auth/forgot-password` | Запрос сброса пароля на email | — |
| POST | `/auth/reset-password` | Установка нового пароля по токену | — |

### Примеры

```http
POST /auth/register
{
  "email": "user@example.com",
  "password": "secret123",
  "firstName": "Иван",
  "lastName": "Петров"
}
→ { accessToken, refreshToken, user }
```

```http
POST /auth/login
{
  "email": "user@example.com",
  "password": "secret123"
}
→ { accessToken, refreshToken, user }
```

---

## Users

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|-----|
| GET | `/users/me` | Получить свой профиль | ✓ |
| PATCH | `/users/me` | Обновить профиль (имя, телефон) | ✓ |
| POST | `/users/me/avatar` | Загрузить фото профиля | ✓ |
| POST | `/users/me/documents` | Загрузить документ (права, паспорт) | ✓ |
| GET | `/users/:id` | Публичный профиль пользователя | — |

### Примеры

```http
PATCH /users/me
Authorization: Bearer <token>
{
  "firstName": "Иван",
  "phone": "+380991234567"
}
→ { user }
```

```http
POST /users/me/documents
Authorization: Bearer <token>
{
  "type": "driving_license",
  "docUrl": "https://storage.supabase.co/..."
}
→ { document }
```

---

## Cars

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|-----|
| GET | `/cars` | Поиск авто с фильтрами | ✓ |
| GET | `/cars/me` | Мои машины (как владелец) | ✓ |
| GET | `/cars/:id` | Детали конкретной машины | ✓ |
| POST | `/cars` | Создать машину | ✓ |
| PATCH | `/cars/:id` | Редактировать машину | ✓ |
| DELETE | `/cars/:id` | Удалить / деактивировать машину | ✓ |
| POST | `/cars/:id/photos` | Добавить фото к машине | ✓ |
| DELETE | `/cars/:id/photos/:photoId` | Удалить фото | — |

### Query параметры для GET /cars

| Параметр | Тип | Описание |
|----------|-----|----------|
| `lat` | Float | Широта центра поиска |
| `lng` | Float | Долгота центра поиска |
| `radius` | Float | Радиус поиска в км |
| `date_from` | Date | Начало периода аренды |
| `date_to` | Date | Конец периода аренды |
| `fuel_type` | String | petrol / diesel / electric / hybrid |
| `transmission` | String | manual / automatic |
| `seats_min` | Int | Минимум мест |
| `price_max` | Float | Максимальная цена за день |
| `limit` | Int | Кол-во результатов (default: 20) |
| `offset` | Int | Смещение для пагинации |

### Примеры

```http
GET /cars?lat=50.45&lng=30.52&radius=10&date_from=2025-06-01&date_to=2025-06-05&fuel_type=petrol
→ { cars: [...], total: 12 }
```

```http
POST /cars
Authorization: Bearer <token>
{
  "brand": "Toyota",
  "model": "Camry",
  "year": 2021,
  "fuelType": "petrol",
  "transmission": "automatic",
  "seats": 5,
  "pricePerDay": 50,
  "deposit": 200,
  "lat": 50.45,
  "lng": 30.52,
  "address": "Киев, ул. Крещатик 1"
}
→ { car }
```

---

## Slots

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|-----|
| GET | `/cars/:id/slots` | Получить доступность машины | ✓ |
| POST | `/cars/:id/slots` | Добавить период доступности | ✓ |
| DELETE | `/cars/:id/slots/:slotId` | Удалить период | ✓ |

### Примеры

```http
POST /cars/:id/slots
Authorization: Bearer <token>
{
  "dateFrom": "2025-06-01",
  "dateTo": "2025-06-30",
  "period_type": "available"
}
→ { slots }
```

---

## Bookings

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|-----|
| POST | `/bookings` | Создать заявку на бронь | ✓ |
| GET | `/bookings/my` | Мои брони как арендатора | ✓ |
| GET | `/bookings/incoming` | Входящие брони (как владелец) | ✓ |
| GET | `/bookings/:id` | Детали конкретной брони | ✓ |
| PATCH | `/bookings/:id/confirm` | Подтвердить бронь (только владелец) | ✓ |
| PATCH | `/bookings/:id/cancel` | Отменить бронь (обе стороны) | ✓ |
| PATCH | `/bookings/:id/complete` | Завершить аренду | — |

### Статус-машина

```
PENDING → CONFIRMED → ACTIVE → COMPLETED
       ↘              ↘
        CANCELLED    CANCELLED
```

### Примеры

```http
POST /bookings
Authorization: Bearer <token>
{
  "carId": "uuid-car",
  "startAt": "2025-06-01T10:00:00Z",
  "endAt": "2025-06-05T10:00:00Z"
}
→ { booking: { id, booking_status: "PENDING", totalPrice: 200 } }
```

```http
PATCH /bookings/:id/confirm
Authorization: Bearer <token>   ← только владелец машины
→ { booking: { booking_status: "CONFIRMED" } }
```

---

## Payments

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|-----|
| POST | `/payments/intent` | Создать Stripe PaymentIntent | — |
| POST | `/payments/webhook` | Вебхук от Stripe | — |
| GET | `/payments/history` | История платежей | — |

> [!warning] MVP
> Весь модуль Payments отложен. В MVP `provider: "cash"`, оплата при передаче ключей.

---

## Reviews

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|-----|
| POST | `/reviews` | Оставить отзыв | ✓ |
| GET | `/reviews/car/:carId` | Отзывы на машину | ✓ |
| GET | `/reviews/user/:userId` | Отзывы на пользователя | — |

### Примеры

```http
POST /reviews
Authorization: Bearer <token>
{
  "carId": "uuid-car",
  "rating": 5,
  "comment": "Отличная машина, всё чисто и вовремя"
}
→ { review }
```

---

## Messages

| Метод | Эндпоинт | Описание | MVP |
|-------|----------|----------|-----|
| GET | `/messages/:bookingId` | История чата по брони | ✓ |
| POST | `/messages/:bookingId` | Отправить сообщение | ✓ |

> [!warning] MVP
> Пока нету но можно реализуеть как простой REST чат. Realtime (WebSocket) — v2.

---

## Итого

| Модуль | Всего | MVP |
|--------|-------|-----|
| Auth | 6 | 4 |
| Users | 5 | 4 |
| Cars | 8 | 7 |
| Slots | 3 | 3 |
| Bookings | 7 | 6 |
| Payments | 3 | 0 |
| Reviews | 3 | 2 |
| Messages | 2 | 2 |
| **Итого** | **38** | **28** |

## Связанные страницы

- [[mvp-scope]] — сокращённый список для MVP
- [[entities]] — сущности БД
