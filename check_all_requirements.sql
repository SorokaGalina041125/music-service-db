-- check_all_requirements.sql
-- Проверка выполнения всех требований заданий

DO $$
DECLARE
    artists_count INT;
    genres_count INT;
    albums_count INT;
    tracks_count INT;
    collections_count INT;
    query1_count INT;
    query2_count INT;
    query3_count INT;
    query4_count INT;
    query5_count INT;
    task3_query1_count INT;
    task3_query2_count INT;
    task3_query3_count INT;
    task3_query4_count INT;
    task3_query5_count INT;
BEGIN
    RAISE NOTICE '=========================================';
    RAISE NOTICE 'ПРОВЕРКА ВСЕХ ТРЕБОВАНИЙ ЗАДАНИЙ';
    RAISE NOTICE '=========================================';
    RAISE NOTICE '';
    
    RAISE NOTICE '=== ЗАДАНИЕ 1: МИНИМАЛЬНЫЕ ТРЕБОВАНИЯ ===';
    
    -- 1. Проверка количества исполнителей
    SELECT COUNT(*) INTO artists_count FROM Artist;
    RAISE NOTICE '1. Исполнители: % (требуется: >=4) %', 
        artists_count, 
        CASE WHEN artists_count >= 4 THEN '✅' ELSE '❌' END;
    
    -- 2. Проверка количества жанров
    SELECT COUNT(*) INTO genres_count FROM Genre;
    RAISE NOTICE '2. Жанры: % (требуется: >=3) %', 
        genres_count, 
        CASE WHEN genres_count >= 3 THEN '✅' ELSE '❌' END;
    
    -- 3. Проверка количества альбомов
    SELECT COUNT(*) INTO albums_count FROM Album;
    RAISE NOTICE '3. Альбомы: % (требуется: >=3) %', 
        albums_count, 
        CASE WHEN albums_count >= 3 THEN '✅' ELSE '❌' END;
    
    -- 4. Проверка количества треков
    SELECT COUNT(*) INTO tracks_count FROM Track;
    RAISE NOTICE '4. Треки: % (требуется: >=6) %', 
        tracks_count, 
        CASE WHEN tracks_count >= 6 THEN '✅' ELSE '❌' END;
    
    -- 5. Проверка количества сборников
    SELECT COUNT(*) INTO collections_count FROM Collection;
    RAISE NOTICE '5. Сборники: % (требуется: >=4) %', 
        collections_count, 
        CASE WHEN collections_count >= 4 THEN '✅' ELSE '❌' END;
    
    RAISE NOTICE '';
    RAISE NOTICE '=== ПРОВЕРКА ЗАПОЛНЕНИЯ ТАБЛИЦ СВЯЗЕЙ ===';
    
    -- Проверка связей исполнитель-жанр
    RAISE NOTICE 'Исполнители без жанров: % (должно быть: 0) %',
        (SELECT COUNT(*) FROM Artist a 
         LEFT JOIN Artist_Genre ag ON a.artist_id = ag.artist_id 
         WHERE ag.artist_id IS NULL),
        CASE WHEN (SELECT COUNT(*) FROM Artist a 
                   LEFT JOIN Artist_Genre ag ON a.artist_id = ag.artist_id 
                   WHERE ag.artist_id IS NULL) = 0 THEN '✅' ELSE '❌' END;
    
    -- Проверка связей исполнитель-альбом
    RAISE NOTICE 'Альбомы без исполнителей: % (должно быть: 0) %',
        (SELECT COUNT(*) FROM Album al 
         LEFT JOIN Artist_Album aa ON al.album_id = aa.album_id 
         WHERE aa.album_id IS NULL),
        CASE WHEN (SELECT COUNT(*) FROM Album al 
                   LEFT JOIN Artist_Album aa ON al.album_id = aa.album_id 
                   WHERE aa.album_id IS NULL) = 0 THEN '✅' ELSE '❌' END;
    
    -- Проверка сборников без треков
    RAISE NOTICE 'Сборники без треков: % (должно быть: 0) %',
        (SELECT COUNT(*) FROM Collection c 
         LEFT JOIN Track_Collection tc ON c.collection_id = tc.collection_id 
         WHERE tc.collection_id IS NULL),
        CASE WHEN (SELECT COUNT(*) FROM Collection c 
                   LEFT JOIN Track_Collection tc ON c.collection_id = tc.collection_id 
                   WHERE tc.collection_id IS NULL) = 0 THEN '✅' ELSE '❌' END;
    
    RAISE NOTICE '';
    RAISE NOTICE '=== ЗАДАНИЕ 2: ПРОВЕРКА НЕПУСТЫХ РЕЗУЛЬТАТОВ ===';
    
    -- Проверка запросов задания 2
    SELECT COUNT(*) INTO query1_count FROM Track WHERE duration = (SELECT MAX(duration) FROM Track);
    RAISE NOTICE '1. Самый длинный трек: % записей %', 
        query1_count,
        CASE WHEN query1_count > 0 THEN '✅' ELSE '❌' END;
    
    SELECT COUNT(*) INTO query2_count FROM Track WHERE duration >= 210;
    RAISE NOTICE '2. Треки ≥ 3.5 мин: % записей %', 
        query2_count,
        CASE WHEN query2_count > 0 THEN '✅' ELSE '❌' END;
    
    SELECT COUNT(*) INTO query3_count FROM Collection WHERE release_year BETWEEN 2018 AND 2020;
    RAISE NOTICE '3. Сборники 2018-2020: % записей %', 
        query3_count,
        CASE WHEN query3_count > 0 THEN '✅' ELSE '❌' END;
    
    SELECT COUNT(*) INTO query4_count FROM Artist WHERE name NOT LIKE '% %' AND name NOT LIKE '%-%';
    RAISE NOTICE '4. Исполнители из 1 слова: % записей %', 
        query4_count,
        CASE WHEN query4_count > 0 THEN '✅' ELSE '❌' END;
    
    SELECT COUNT(*) INTO query5_count FROM Track WHERE title ILIKE '%мой%' OR title ILIKE '%my%';
    RAISE NOTICE '5. Треки с "мой" или "my": % записей %', 
        query5_count,
        CASE WHEN query5_count > 0 THEN '✅' ELSE '❌' END;
    
    RAISE NOTICE '';
    RAISE NOTICE '=== ЗАДАНИЕ 3: ПРОВЕРКА НЕПУСТЫХ РЕЗУЛЬТАТОВ ===';
    
    -- Проверка запросов задания 3
    -- 1. Количество исполнителей в каждом жанре
    SELECT COUNT(*) INTO task3_query1_count FROM (
        SELECT g.name, COUNT(DISTINCT ag.artist_id)
        FROM Genre g
        LEFT JOIN Artist_Genre ag ON g.genre_id = ag.genre_id
        GROUP BY g.genre_id, g.name
        HAVING COUNT(DISTINCT ag.artist_id) > 0
    ) as subquery;
    RAISE NOTICE '1. Исполнители по жанрам: % записей %', 
        task3_query1_count,
        CASE WHEN task3_query1_count > 0 THEN '✅' ELSE '❌' END;
    
    -- 2. Количество треков в альбомах 2019-2020
    SELECT COUNT(*) INTO task3_query2_count FROM Track t
    JOIN Album a ON t.album_id = a.album_id
    WHERE a.release_year BETWEEN 2019 AND 2020;
    RAISE NOTICE '2. Треки в альбомах 2019-2020: % записей %', 
        task3_query2_count,
        CASE WHEN task3_query2_count > 0 THEN '✅' ELSE '❌' END;
    
    -- 3. Средняя продолжительность по альбомам
    SELECT COUNT(*) INTO task3_query3_count FROM Album a
    JOIN Track t ON a.album_id = t.album_id
    GROUP BY a.album_id;
    RAISE NOTICE '3. Средняя продолжительность: % альбомов %', 
        task3_query3_count,
        CASE WHEN task3_query3_count > 0 THEN '✅' ELSE '❌' END;
    
    -- 4. Исполнители без альбомов 2020
    SELECT COUNT(*) INTO task3_query4_count FROM Artist ar
    WHERE ar.artist_id NOT IN (
        SELECT DISTINCT aa.artist_id
        FROM Artist_Album aa
        JOIN Album al ON aa.album_id = al.album_id
        WHERE al.release_year = 2020
    );
    RAISE NOTICE '4. Исполнители без альбомов 2020: % записей %', 
        task3_query4_count,
        CASE WHEN task3_query4_count > 0 THEN '✅' ELSE '❌' END;
    
    -- 5. Сборники с исполнителем
    SELECT COUNT(*) INTO task3_query5_count FROM (
        SELECT DISTINCT c.collection_id
        FROM Collection c
        JOIN Track_Collection tc ON c.collection_id = tc.collection_id
        JOIN Track t ON tc.track_id = t.track_id
        JOIN Artist_Album aa ON t.album_id = aa.album_id
        JOIN Artist a ON aa.artist_id = a.artist_id
        WHERE a.name = 'Король и Шут'
    ) as subquery;
    RAISE NOTICE '5. Сборники с Король и Шут: % записей %', 
        task3_query5_count,
        CASE WHEN task3_query5_count > 0 THEN '✅' ELSE '❌' END;
    
    RAISE NOTICE '';
    RAISE NOTICE '=== ИТОГОВАЯ ПРОВЕРКА ===';
    
    IF artists_count >= 4 AND genres_count >= 3 AND albums_count >= 3 
       AND tracks_count >= 6 AND collections_count >= 4 THEN
        RAISE NOTICE '✅ ВСЕ ТРЕБОВАНИЯ ЗАДАНИЯ 1 ВЫПОЛНЕНЫ!';
    ELSE
        RAISE NOTICE '❌ НЕ ВСЕ ТРЕБОВАНИЯ ЗАДАНИЯ 1 ВЫПОЛНЕНЫ';
    END IF;
    
    IF query1_count > 0 AND query2_count > 0 AND query3_count > 0 
       AND query4_count > 0 AND query5_count > 0 THEN
        RAISE NOTICE '✅ ЗАПРОСЫ ЗАДАНИЯ 2 ВОЗВРАЩАЮТ РЕЗУЛЬТАТЫ!';
    ELSE
        RAISE NOTICE '❌ НЕКОТОРЫЕ ЗАПРОСЫ ЗАДАНИЯ 2 НЕ РАБОТАЮТ';
    END IF;
    
END $$;