# Film App

Flutter приложение для просмотра фильмов с использованием чистой архитектуры и BLoC.

## Функциональность

- 📱 Просмотр популярных фильмов
- 🔍 Поиск фильмов
- 📄 Детальная информация о фильмах
- 🎨 Material Design 3
- ♾️ Бесконечная прокрутка
- 🖼️ Кэширование изображений

## Архитектура

Проект построен с использованием **Clean Architecture** и состоит из трех основных слоев:

### Domain Layer
- **Entities**: Бизнес-объекты (`Movie`, `MovieDetails`)
- **Repositories**: Интерфейсы для доступа к данным
- **Use Cases**: Бизнес-логика приложения

### Data Layer  
- **Models**: DTO для API (`MovieModel`, `MovieDetailsModel`)
- **Data Sources**: Источники данных (Remote API)
- **Repository Implementations**: Реализация интерфейсов из Domain слоя

### Presentation Layer
- **BLoC**: Управление состоянием (`MovieBloc`, `MovieDetailsBloc`)
- **Pages**: UI экраны
- **Widgets**: Переиспользуемые UI компоненты

## Настройка проекта

### 1. Клонирование репозитория

\`\`\`bash
git clone <repository-url>
cd film_app
\`\`\`

### 2. Настройка переменных окружения

1. Скопируйте файл `.env.example` в `.env`:
\`\`\`bash
cp .env.example .env
\`\`\`

2. Получите API ключ от TMDB:
   - Зарегистрируйтесь на [The Movie Database](https://www.themoviedb.org/)
   - Перейдите в [API Settings](https://www.themoviedb.org/settings/api)
   - Скопируйте ваш API ключ

3. Откройте файл `.env` и замените `your_api_key_from_tmdb_here` на ваш настоящий API ключ:
\`\`\`
TMDB_API_KEY=ваш_настоящий_api_ключ_здесь
\`\`\`

### 3. Установка зависимостей

\`\`\`bash
flutter pub get
\`\`\`

### 4. Запуск приложения

\`\`\`bash
flutter run
\`\`\`

## Используемые пакеты

- **State Management**: flutter_bloc, bloc
- **HTTP Client**: dio  
- **Dependency Injection**: get_it
- **Functional Programming**: dartz
- **Image Caching**: cached_network_image
- **Environment Variables**: flutter_dotenv
- **Value Equality**: equatable

## Безопасность

- ✅ API ключи хранятся в `.env` файле
- ✅ `.env` файл исключен из Git (добавлен в `.gitignore`)  
- ✅ Предоставлен `.env.example` с инструкциями
- ✅ Проверка наличия API ключа при запуске

## Структура проекта

\`\`\`
lib/
├── core/
│   ├── constants/
│   └── network/
├── features/
│   └── movies/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── injection_container.dart
└── main.dart
\`\`\`
