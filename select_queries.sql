-- select_queries.sql
-- Задание 2: Базовые SELECT-запросы

-- 1. Название и продолжительность самого длительного трека
SELECT 
    title AS "Название трека",
    duration AS "Продолжительность (сек)",
    CONCAT(FLOOR(duration / 60), ':', LPAD(duration % 60, 2, '0')) AS "Продолжительность (мм:сс)"
FROM Track
WHERE duration = (SELECT MAX(duration) FROM Track);

-- 2. Название треков, продолжительность которых не менее 3,5 минут (210 секунд)
SELECT 
    title AS "Название трека",
    duration AS "Продолжительность (сек)",
    CONCAT(FLOOR(duration / 60), ':', LPAD(duration % 60, 2, '0')) AS "Продолжительность (мм:сс)"
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

-- 5. Название треков, которые содержат слово «мой» или «my»
SELECT 
    title AS "Трек содержит 'мой' или 'my'"
FROM Track
WHERE title ILIKE '%мой%' OR title ILIKE '%my%'
ORDER BY title;