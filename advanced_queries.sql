-- advanced_queries.sql
-- Задание 3: Продвинутые SELECT-запросы

-- 1. Количество исполнителей в каждом жанре (с выводом всех жанров)
SELECT 
    g.name AS "Жанр",
    COUNT(DISTINCT ag.artist_id) AS "Количество исполнителей"
FROM Genre g
LEFT JOIN Artist_Genre ag ON g.genre_id = ag.genre_id
GROUP BY g.genre_id, g.name
ORDER BY "Количество исполнителей" DESC, "Жанр";

-- 2. Количество треков, вошедших в альбомы 2019–2020 годов
SELECT 
    COUNT(t.track_id) AS "Количество треков в альбомах 2019-2020"
FROM Track t
JOIN Album a ON t.album_id = a.album_id
WHERE a.release_year BETWEEN 2019 AND 2020;

-- 3. Средняя продолжительность треков по каждому альбому
SELECT 
    a.title AS "Альбом",
    a.release_year AS "Год выпуска",
    COUNT(t.track_id) AS "Количество треков",
    ROUND(AVG(t.duration), 1) AS "Средняя продолжительность (сек)",
    CONCAT(FLOOR(AVG(t.duration) / 60), ':', RIGHT('0' || ROUND(AVG(t.duration) % 60)::INT, 2)) AS "Средняя продолжительность (мм:сс)"
FROM Album a
JOIN Track t ON a.album_id = t.album_id
GROUP BY a.album_id, a.title, a.release_year
ORDER BY "Средняя продолжительность (сек)" DESC, "Год выпуска" DESC;

-- 4. Все исполнители, которые не выпустили альбомы в 2020 году
SELECT 
    ar.name AS "Исполнитель (не выпускал альбомы в 2020)"
FROM Artist ar
WHERE ar.artist_id NOT IN (
    SELECT DISTINCT aa.artist_id
    FROM Artist_Album aa
    JOIN Album al ON aa.album_id = al.album_id
    WHERE al.release_year = 2020
)
ORDER BY ar.name;

-- 5. Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами)
-- Выбираем исполнителя 'Максим'
SELECT DISTINCT
    c.title AS "Сборник с исполнителем 'Максим'",
    c.release_year AS "Год выпуска сборника",
    ar.name AS "Исполнитель"
FROM Collection c
JOIN Track_Collection tc ON c.collection_id = tc.collection_id
JOIN Track t ON tc.track_id = t.track_id
JOIN Album a ON t.album_id = a.album_id
JOIN Artist_Album aa ON a.album_id = aa.album_id
JOIN Artist ar ON aa.artist_id = ar.artist_id
WHERE ar.name = 'Максим'
ORDER BY c.release_year DESC, c.title;