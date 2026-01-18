-- optional_queries.sql
-- Задание 4: Необязательные SELECT-запросы

-- 1. Названия альбомов, в которых присутствуют исполнители более чем одного жанра
WITH AlbumArtistGenres AS (
    SELECT 
        a.album_id,
        a.title,
        a.release_year,
        ag.artist_id,
        COUNT(DISTINCT g.genre_id) as genre_count
    FROM Album a
    JOIN Artist_Album aa ON a.album_id = aa.album_id
    JOIN Artist_Genre ag ON aa.artist_id = ag.artist_id
    JOIN Genre g ON ag.genre_id = g.genre_id
    GROUP BY a.album_id, a.title, a.release_year, ag.artist_id
    HAVING COUNT(DISTINCT g.genre_id) > 1
)
SELECT DISTINCT
    title AS "Альбом",
    release_year AS "Год выпуска"
FROM AlbumArtistGenres
ORDER BY release_year DESC, title;

-- 2. Наименования треков, которые не входят в сборники
SELECT 
    t.title AS "Трек не в сборниках",
    a.title AS "Альбом",
    ar.name AS "Исполнитель",
    CONCAT(FLOOR(t.duration / 60), ':', RIGHT('0' || (t.duration % 60), 2)) AS "Длительность"
FROM Track t
LEFT JOIN Track_Collection tc ON t.track_id = tc.track_id
JOIN Album a ON t.album_id = a.album_id
JOIN Artist_Album aa ON a.album_id = aa.album_id
JOIN Artist ar ON aa.artist_id = ar.artist_id
WHERE tc.track_id IS NULL
ORDER BY t.title;

-- 3. Исполнитель или исполнители, написавшие самый короткий по продолжительности трек
SELECT DISTINCT
    ar.name AS "Исполнитель",
    t.title AS "Самый короткий трек",
    t.duration AS "Длительность (сек)",
    CONCAT(FLOOR(t.duration / 60), ':', RIGHT('0' || (t.duration % 60), 2)) AS "Длительность (мм:сс)"
FROM Track t
JOIN Album a ON t.album_id = a.album_id
JOIN Artist_Album aa ON a.album_id = aa.album_id
JOIN Artist ar ON aa.artist_id = ar.artist_id
WHERE t.duration = (SELECT MIN(duration) FROM Track)
ORDER BY ar.name, t.title;

-- 4. Названия альбомов, содержащих наименьшее количество треков
WITH AlbumTrackCount AS (
    SELECT 
        a.album_id,
        a.title AS album_title,
        a.release_year,
        COUNT(t.track_id) AS track_count
    FROM Album a
    LEFT JOIN Track t ON a.album_id = t.album_id
    GROUP BY a.album_id, a.title, a.release_year
)
SELECT 
    album_title AS "Альбом с наименьшим числом треков",
    release_year AS "Год выпуска",
    track_count AS "Количество треков"
FROM AlbumTrackCount
WHERE track_count = (SELECT MIN(track_count) FROM AlbumTrackCount)
ORDER BY album_title;