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
('Авторская песня'),
('Шансон');

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

-- Сборники
INSERT INTO Collection (title, release_year) VALUES 
('Лучшие русские рок-хиты', 2020),
('Поп-хиты 2000-х', 2021),
('Легенды русского рока', 2019),
('Золотая коллекция', 2022),
('Хиты 90-х', 2023),
('Новая волна', 2022),
('Дискотека 2000', 2021),
('Русский шансон', 2020);

-- Связи: Исполнитель-Жанр
INSERT INTO Artist_Genre (artist_id, genre_id) VALUES 
(1, 1),  -- Король и Шут -> Рок
(1, 3),  -- Король и Шут -> Панк-рок
(1, 4),  -- Король и Шут -> Фолк-рок
(2, 2),  -- Максим -> Поп
(2, 5),  -- Максим -> Поп-рок
(3, 1),  -- Ленинград -> Рок
(3, 4),  -- Ленинград -> Фолк-рок
(3, 10), -- Ленинград -> Шансон
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

-- Связи: Трек-Сборник
INSERT INTO Track_Collection (track_id, collection_id) VALUES 
(1, 1),   -- Лесник -> Лучшие русские рок-хиты
(1, 3),   -- Лесник -> Легенды русского рока
(1, 5),   -- Лесник -> Хиты 90-х
(3, 2),   -- Знаешь ли ты -> Поп-хиты 2000-х
(3, 7),   -- Знаешь ли ты -> Дискотека 2000
(4, 2),   -- Мой рай -> Поп-хиты 2000-х
(5, 4),   -- Экспонат -> Золотая коллекция
(5, 6),   -- Экспонат -> Новая волна
(7, 4),   -- Встань -> Золотая коллекция
(7, 6),   -- Встань -> Новая волна
(9, 2),   -- Колыбельная -> Поп-хиты 2000-х
(9, 4),   -- Колыбельная -> Золотая коллекция
(11, 2),  -- Космос -> Поп-хиты 2000-х
(11, 6),  -- Космос -> Новая волна
(13, 1),  -- Группа крови -> Лучшие русские рок-хиты
(13, 3),  -- Группа крови -> Легенды русского рока
(13, 5),  -- Группа крови -> Хиты 90-х
(15, 2),  -- Тучи -> Поп-хиты 2000-х
(15, 7),  -- Тучи -> Дискотека 2000
(17, 2),  -- 18 мне уже -> Поп-хиты 2000-х
(17, 5),  -- 18 мне уже -> Хиты 90-х
(17, 7),  -- 18 мне уже -> Дискотека 2000
(19, 2),  -- Между нами тает лед -> Поп-хиты 2000-х
(19, 7);  -- Между нами тает лед -> Дискотека 2000

-- ============================================
-- ПРОВЕРОЧНЫЕ ЗАПРОСЫ
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

-- Показать всех исполнителей
SELECT '=== ВСЕ ИСПОЛНИТЕЛИ ===' as info;
SELECT artist_id as "ID", name as "Имя исполнителя" FROM Artist ORDER BY name;

-- Показать все треки с альбомами
SELECT '=== ТРЕКИ И АЛЬБОМЫ ===' as info;
SELECT t.title as "Трек", t.duration as "Длительность", 
       a.title as "Альбом", a.release_year as "Год"
FROM Track t
JOIN Album a ON t.album_id = a.album_id
ORDER BY t.title;

-- Проверка связей многие-ко-многим
SELECT '=== ИСПОЛНИТЕЛИ С НЕСКОЛЬКИМИ ЖАНРАМИ ===' as info;
SELECT a.name as "Исполнитель", 
       COUNT(g.genre_id) as "Количество жанров",
       STRING_AGG(g.name, ', ') as "Жанры"
FROM Artist a
JOIN Artist_Genre ag ON a.artist_id = ag.artist_id
JOIN Genre g ON ag.genre_id = g.genre_id
GROUP BY a.artist_id, a.name
HAVING COUNT(g.genre_id) > 1
ORDER BY COUNT(g.genre_id) DESC;

SELECT '=== АЛЬБОМЫ С НЕСКОЛЬКИМИ ИСПОЛНИТЕЛЯМИ ===' as info;
SELECT al.title as "Альбом", al.release_year as "Год",
       COUNT(DISTINCT aa.artist_id) as "Количество исполнителей",
       STRING_AGG(ar.name, ', ') as "Исполнители"
FROM Album al
JOIN Artist_Album aa ON al.album_id = aa.album_id
JOIN Artist ar ON aa.artist_id = ar.artist_id
GROUP BY al.album_id, al.title, al.release_year
HAVING COUNT(DISTINCT aa.artist_id) > 1
ORDER BY COUNT(DISTINCT aa.artist_id) DESC;

SELECT '=== ТРЕКИ В НЕСКОЛЬКИХ СБОРНИКАХ ===' as info;
SELECT t.title as "Трек", 
       COUNT(DISTINCT tc.collection_id) as "Количество сборников",
       STRING_AGG(c.title, ', ') as "Сборники"
FROM Track t
JOIN Track_Collection tc ON t.track_id = tc.track_id
JOIN Collection c ON tc.collection_id = c.collection_id
GROUP BY t.track_id, t.title
HAVING COUNT(DISTINCT tc.collection_id) > 1
ORDER BY COUNT(DISTINCT tc.collection_id) DESC;

-- Проверка выполнения требований задания
SELECT '=== ПРОВЕРКА ВЫПОЛНЕНИЯ ТРЕБОВАНИЙ ===' as info;
SELECT 
    '1. Исполнители в разных жанрах (многие-ко-многим)' as requirement,
    CASE WHEN EXISTS (
        SELECT 1 FROM Artist_Genre GROUP BY artist_id HAVING COUNT(*) > 1
    ) THEN '✅ Выполнено' ELSE '❌ Не выполнено' END as status
UNION ALL
SELECT 
    '2. Альбомы с несколькими исполнителями (многие-ко-многим)',
    CASE WHEN EXISTS (
        SELECT 1 FROM Artist_Album GROUP BY album_id HAVING COUNT(*) > 1
    ) THEN '✅ Выполнено' ELSE '❌ Не выполнено' END
UNION ALL
SELECT 
    '3. Треки в разных сборниках (многие-ко-многим)',
    CASE WHEN EXISTS (
        SELECT 1 FROM Track_Collection GROUP BY track_id HAVING COUNT(*) > 1
    ) THEN '✅ Выполнено' ELSE '❌ Не выполнено' END
UNION ALL
SELECT 
    '4. Все 9 указанных исполнителей добавлены',
    CASE WHEN (SELECT COUNT(*) FROM Artist) = 9 
         THEN '✅ Выполнено (9 исполнителей)' 
         ELSE '❌ Не выполнено' END;