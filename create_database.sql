-- ============================================
-- БАЗА ДАННЫХ МУЗЫКАЛЬНОГО СЕРВИСА
-- Автор: Галина Сорока
-- GitHub: https://github.com/SorokaGalina041125
-- Дата: 2026
-- ============================================

-- Удаляем таблицы, если они существуют (в обратном порядке зависимостей)
DROP TABLE IF EXISTS Track_Collection CASCADE;
DROP TABLE IF EXISTS Collection CASCADE;
DROP TABLE IF EXISTS Track CASCADE;
DROP TABLE IF EXISTS Artist_Album CASCADE;
DROP TABLE IF EXISTS Album CASCADE;
DROP TABLE IF EXISTS Artist_Genre CASCADE;
DROP TABLE IF EXISTS Artist CASCADE;
DROP TABLE IF EXISTS Genre CASCADE;

-- 1. Таблица: Жанры
CREATE TABLE Genre (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Таблица: Исполнители
CREATE TABLE Artist (
    artist_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- 3. Связь: Исполнитель-Жанр (многие-ко-многим)
CREATE TABLE Artist_Genre (
    artist_genre_id SERIAL PRIMARY KEY,
    artist_id INT NOT NULL REFERENCES Artist(artist_id) ON DELETE CASCADE,
    genre_id INT NOT NULL REFERENCES Genre(genre_id) ON DELETE CASCADE,
    UNIQUE (artist_id, genre_id)
);

-- 4. Таблица: Альбомы
CREATE TABLE Album (
    album_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INT CHECK (release_year >= 1900 AND release_year <= EXTRACT(YEAR FROM CURRENT_DATE) + 1)
);

-- 5. Связь: Исполнитель-Альбом (многие-ко-многим)
CREATE TABLE Artist_Album (
    artist_album_id SERIAL PRIMARY KEY,
    artist_id INT NOT NULL REFERENCES Artist(artist_id) ON DELETE CASCADE,
    album_id INT NOT NULL REFERENCES Album(album_id) ON DELETE CASCADE,
    UNIQUE (artist_id, album_id)
);

-- 6. Таблица: Треки
CREATE TABLE Track (
    track_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    duration INT NOT NULL CHECK (duration > 0),
    album_id INT NOT NULL REFERENCES Album(album_id) ON DELETE CASCADE
);

-- 7. Таблица: Сборники
CREATE TABLE Collection (
    collection_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INT NOT NULL CHECK (release_year >= 1900 AND release_year <= EXTRACT(YEAR FROM CURRENT_DATE) + 1)
);

-- 8. Связь: Трек-Сборник (многие-ко-многим)
CREATE TABLE Track_Collection (
    track_collection_id SERIAL PRIMARY KEY,
    track_id INT NOT NULL REFERENCES Track(track_id) ON DELETE CASCADE,
    collection_id INT NOT NULL REFERENCES Collection(collection_id) ON DELETE CASCADE,
    UNIQUE (track_id, collection_id)
);

-- Создаем индексы для ускорения поиска
CREATE INDEX idx_artist_name ON Artist(name);
CREATE INDEX idx_genre_name ON Genre(name);
CREATE INDEX idx_album_title ON Album(title);
CREATE INDEX idx_track_title ON Track(title);
CREATE INDEX idx_collection_title ON Collection(title);

-- ============================================
-- ТЕСТОВЫЕ ДАННЫЕ
-- ============================================

-- Жанры
INSERT INTO Genre (name) VALUES 
('Рок'),
('Поп'),
('Панк-рок'),
('Фолк-рок'),
('Поп-рок'),
('Хип-Хоп'),
('Электроника'),
('Диско'),
('Авторская песня');

-- Исполнители
INSERT INTO Artist (name) VALUES 
('Король и Шут'),
('Максим'),
('Ленинград'),
('Shaman'),
('Полина Гагарина'),
('Mia Boyka'),
('Виктор Цой'),
('Иванушки International'),
('Руки Вверх!');

-- Альбомы
INSERT INTO Album (title, release_year) VALUES 
('Акустический альбом', 1999),
('Трудный возраст', 2006),
('Маленький', 2017),
('Встань', 2022),
('Попроси у облаков', 2007),
('Космос', 2021),
('Группа крови', 1988),
('Конечно он', 1996),
('Сделай погромче!', 1999),
('Сборник хитов', 2020),
('Рок-легенды', 2019),
('Поп-хиты 2000-х', 2021);

-- Треки
INSERT INTO Track (title, duration, album_id) VALUES 
('Лесник', 240, 1),
('Прыгну со скалы', 210, 1),
('Знаешь ли ты', 180, 2),
('Мой рай', 220, 2),
('Экспонат', 195, 3),
('В Питере - пить', 245, 3),
('Встань', 210, 4),
('Я русский', 230, 4),
('Колыбельная', 265, 5),
('Спектакль окончен', 245, 5),
('Космос', 225, 6),
('Не нужна', 195, 6),
('Группа крови', 270, 7),
('Звезда по имени Солнце', 285, 7),
('Тучи', 210, 8),
('Колечко', 195, 8),
('18 мне уже', 180, 9),
('Мальчик-гей', 220, 9),
('Между нами тает лед', 245, 10),
('Он тебя целует', 230, 10);

-- Сборники (7 сборников, все с треками)
INSERT INTO Collection (title, release_year) VALUES 
('Лучшие русские рок-хиты', 2020),
('Поп-хиты 2000-х', 2021),
('Легенды русского рока', 2019),
('Золотая коллекция', 2022),
('Хиты 90-х', 2023),
('Новая волна', 2022),
('Дискотека 2000', 2021);

-- Связи: Исполнитель-Жанр
INSERT INTO Artist_Genre (artist_id, genre_id) VALUES 
(1, 1),  -- Король и Шут -> Рок
(1, 3),  -- Король и Шут -> Панк-рок
(1, 4),  -- Король и Шут -> Фолк-рок
(2, 2),  -- Максим -> Поп
(2, 5),  -- Максим -> Поп-рок
(3, 1),  -- Ленинград -> Рок
(3, 4),  -- Ленинград -> Фолк-рок
(4, 2),  -- Shaman -> Поп
(4, 5),  -- Shaman -> Поп-рок
(5, 2),  -- Полина Гагарина -> Поп
(5, 5),  -- Полина Гагарина -> Поп-рок
(6, 2),  -- Mia Boyka -> Поп
(6, 7),  -- Mia Boyka -> Электроника
(7, 1),  -- Виктор Цой -> Рок
(7, 9),  -- Виктор Цой -> Авторская песня
(8, 2),  -- Иванушки International -> Поп
(8, 8),  -- Иванушки International -> Диско
(9, 2),  -- Руки Вверх! -> Поп
(9, 8);  -- Руки Вверх! -> Диско

-- Связи: Исполнитель-Альбом
INSERT INTO Artist_Album (artist_id, album_id) VALUES 
(1, 1),   -- Король и Шут -> Акустический альбом
(2, 2),   -- Максим -> Трудный возраст
(3, 3),   -- Ленинград -> Маленький
(4, 4),   -- Shaman -> Встань
(5, 5),   -- Полина Гагарина -> Попроси у облаков
(6, 6),   -- Mia Boyka -> Космос
(7, 7),   -- Виктор Цой -> Группа крови
(8, 8),   -- Иванушки International -> Конечно он
(9, 9),   -- Руки Вверх! -> Сделай погромче!
(1, 10),  -- Король и Шут -> Сборник хитов (совместный)
(2, 10),  -- Максим -> Сборник хитов (совместный)
(7, 11),  -- Виктор Цой -> Рок-легенды (сборник)
(2, 12),  -- Максим -> Поп-хиты 2000-х (сборник)
(8, 12),  -- Иванушки International -> Поп-хиты 2000-х (сборник)
(9, 12);  -- Руки Вверх! -> Поп-хиты 2000-х (сборник)

-- Связи: Трек-Сборник (УБЕДИТЕСЬ, что ВСЕ сборники имеют треки)
INSERT INTO Track_Collection (track_id, collection_id) VALUES 
-- Сборник 1: Лучшие русские рок-хиты
(1, 1),   -- Лесник
(13, 1),  -- Группа крови
-- Сборник 2: Поп-хиты 2000-х
(3, 2),   -- Знаешь ли ты
(4, 2),   -- Мой рай
(9, 2),   -- Колыбельная
(11, 2),  -- Космос
(15, 2),  -- Тучи
(17, 2),  -- 18 мне уже
(19, 2),  -- Между нами тает лед
-- Сборник 3: Легенды русского рока
(1, 3),   -- Лесник
(13, 3),  -- Группа крови
-- Сборник 4: Золотая коллекция
(5, 4),   -- Экспонат
(7, 4),   -- Встань
(9, 4),   -- Колыбельная
-- Сборник 5: Хиты 90-х
(1, 5),   -- Лесник
(13, 5),  -- Группа крови
(17, 5),  -- 18 мне уже
-- Сборник 6: Новая волна
(5, 6),   -- Экспонат
(7, 6),   -- Встань
(11, 6),  -- Космос
-- Сборник 7: Дискотека 2000
(3, 7),   -- Знаешь ли ты
(15, 7),  -- Тучи
(17, 7),  -- 18 мне уже
(19, 7);  -- Между нами тает лед

-- ============================================
-- ПРОВЕРКА СООТВЕТСТВИЯ ТРЕБОВАНИЯМ ЗАДАНИЯ 1
-- ============================================

DO $$
DECLARE
    artists_count INT;
    genres_count INT;
    albums_count INT;
    tracks_count INT;
    collections_count INT;
    empty_collections INT;
BEGIN
    -- Сбор статистики
    SELECT COUNT(*) INTO artists_count FROM Artist;
    SELECT COUNT(*) INTO genres_count FROM Genre;
    SELECT COUNT(*) INTO albums_count FROM Album;
    SELECT COUNT(*) INTO tracks_count FROM Track;
    SELECT COUNT(*) INTO collections_count FROM Collection;
    
    -- Проверка сборников без треков
    SELECT COUNT(*) INTO empty_collections
    FROM Collection c
    LEFT JOIN Track_Collection tc ON c.collection_id = tc.collection_id
    WHERE tc.collection_id IS NULL;
    
    -- Вывод результатов
    RAISE NOTICE '=== ПРОВЕРКА ТРЕБОВАНИЙ ЗАДАНИЯ 1 ===';
    RAISE NOTICE '';
    RAISE NOTICE '1. Исполнители: % (требуется: >=4) %', 
        artists_count, 
        CASE WHEN artists_count >= 4 THEN '✅' ELSE '❌' END;
    RAISE NOTICE '2. Жанры: % (требуется: >=3) %', 
        genres_count, 
        CASE WHEN genres_count >= 3 THEN '✅' ELSE '❌' END;
    RAISE NOTICE '3. Альбомы: % (требуется: >=3) %', 
        albums_count, 
        CASE WHEN albums_count >= 3 THEN '✅' ELSE '❌' END;
    RAISE NOTICE '4. Треки: % (требуется: >=6) %', 
        tracks_count, 
        CASE WHEN tracks_count >= 6 THEN '✅' ELSE '❌' END;
    RAISE NOTICE '5. Сборники: % (требуется: >=4) %', 
        collections_count, 
        CASE WHEN collections_count >= 4 THEN '✅' ELSE '❌' END;
    RAISE NOTICE '6. Сборники без треков: % (должно быть: 0) %', 
        empty_collections, 
        CASE WHEN empty_collections = 0 THEN '✅' ELSE '❌' END;
    RAISE NOTICE '';
    
    -- Итоговый вердикт
    IF artists_count >= 4 AND genres_count >= 3 AND albums_count >= 3 AND 
       tracks_count >= 6 AND collections_count >= 4 AND empty_collections = 0 THEN
        RAISE NOTICE '=== ИТОГ: ✅ ВСЕ ТРЕБОВАНИЯ ВЫПОЛНЕНЫ! ===';
    ELSE
        RAISE NOTICE '=== ИТОГ: ❌ НЕ ВСЕ ТРЕБОВАНИЯ ВЫПОЛНЕНЫ ===';
    END IF;
END $$;

-- ============================================
-- ДОПОЛНИТЕЛЬНЫЕ ПРОВЕРОЧНЫЕ ЗАПРОСЫ
-- ============================================

-- Показать все таблицы
SELECT '=== ВСЕ ТАБЛИЦЫ В БАЗЕ ===' as info;
SELECT tablename 
FROM pg_tables 
WHERE schemaname = 'public' 
ORDER BY tablename;

-- Количество записей в каждой таблице
SELECT '=== КОЛИЧЕСТВО ЗАПИСЕЙ ===' as info;
SELECT 'Genre' as table_name, COUNT(*) as record_count FROM Genre
UNION ALL
SELECT 'Artist', COUNT(*) FROM Artist
UNION ALL
SELECT 'Album', COUNT(*) FROM Album
UNION ALL
SELECT 'Track', COUNT(*) FROM Track
UNION ALL
SELECT 'Collection', COUNT(*) FROM Collection
UNION ALL
SELECT 'Artist_Genre', COUNT(*) FROM Artist_Genre
UNION ALL
SELECT 'Artist_Album', COUNT(*) FROM Artist_Album
UNION ALL
SELECT 'Track_Collection', COUNT(*) FROM Track_Collection;
