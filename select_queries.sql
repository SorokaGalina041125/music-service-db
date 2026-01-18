-- select_queries.sql
-- Задание 2: Базовые SELECT-запросы

-- 1. Название и продолжительность самого длительного трека
SELECT 
    title AS "Название трека",
    duration AS "Продолжительность (сек)",
    CONCAT(FLOOR(duration / 60), ':', TO_CHAR(duration % 60, 'FM00')) AS "Продолжительность (мм:сс)"
FROM Track
WHERE duration = (SELECT MAX(duration) FROM Track);

-- 2. Название треков, продолжительность которых не менее 3,5 минут (210 секунд)
SELECT 
    title AS "Название трека",
    duration AS "Продолжительность (сек)",
    CONCAT(FLOOR(duration / 60), ':', TO_CHAR(duration % 60, 'FM00')) AS "Продолжительность (мм:сс)"
FROM Track
WHERE duration >= 210
ORDER BY duration DESC;

-- 3. Названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT 
    title AS "Название сборника",
    release_year AS "Год выпуска"
FROM Collection
WHERE release_year BETWEEN 2018 AND 2020
ORDER BY release_year;

-- 4. Исполнители, чьё имя состоит из одного слова
SELECT 
    name AS "Исполнитель (одно слово)"
FROM Artist
WHERE name NOT LIKE '% %' AND name NOT LIKE '%-%'
ORDER BY name;

-- 5. Название треков, которые содержат слово «мой» или «my» (целые слова)
SELECT 
    title AS "Трек содержит 'мой' или 'my'"
FROM Track
WHERE 
    -- Слово "мой" в начале строки
    title ILIKE 'мой %' 
    OR title ILIKE 'мой'  -- только слово "мой"
    -- Слово "мой" в конце строки
    OR title ILIKE '% мой' 
    OR title ILIKE '% мой.' 
    OR title ILIKE '% мой!' 
    OR title ILIKE '% мой?' 
    -- Слово "мой" в середине строки
    OR title ILIKE '% мой %'
    -- Слово "my" в начале строки
    OR title ILIKE 'my %'
    OR title ILIKE 'my'  -- только слово "my"
    -- Слово "my" в конце строки
    OR title ILIKE '% my' 
    OR title ILIKE '% my.' 
    OR title ILIKE '% my!' 
    OR title ILIKE '% my?' 
    -- Слово "my" в середине строки
    OR title ILIKE '% my %'
ORDER BY title;