-- check_requirements.sql
-- Проверка выполнения всех требований задания

DO $$
BEGIN
    RAISE NOTICE '=== ПРОВЕРКА ТРЕБОВАНИЙ ЗАДАНИЯ 1 ===';
    RAISE NOTICE '';
    
    -- 1. Проверка количества исполнителей
    RAISE NOTICE '1. Исполнители: % (требуется: >=4)', 
        (SELECT COUNT(*) FROM artist);
    
    -- 2. Проверка количества жанров
    RAISE NOTICE '2. Жанры: % (требуется: >=3)', 
        (SELECT COUNT(*) FROM genre);
    
    -- 3. Проверка количества альбомов
    RAISE NOTICE '3. Альбомы: % (требуется: >=3)', 
        (SELECT COUNT(*) FROM album);
    
    -- 4. Проверка количества треков
    RAISE NOTICE '4. Треки: % (требуется: >=6)', 
        (SELECT COUNT(*) FROM track);
    
    -- 5. Проверка количества сборников
    RAISE NOTICE '5. Сборники: % (требуется: >=4)', 
        (SELECT COUNT(*) FROM collection);
    
    RAISE NOTICE '';
    RAISE NOTICE '=== ПРОВЕРКА СВЯЗЕЙ ===';
    RAISE NOTICE '';
    
    -- 6. Проверка связей исполнитель-жанр
    RAISE NOTICE '6. Исполнители без жанров: % (должно быть: 0)',
        (SELECT COUNT(*) FROM artist a 
         LEFT JOIN artist_genre ag ON a.artist_id = ag.artist_id 
         WHERE ag.artist_id IS NULL);
    
    -- 7. Проверка связей исполнитель-альбом
    RAISE NOTICE '7. Альбомы без исполнителей: % (должно быть: 0)',
        (SELECT COUNT(*) FROM album al 
         LEFT JOIN artist_album aa ON al.album_id = aa.album_id 
         WHERE aa.album_id IS NULL);
    
    -- 8. Проверка связей трек-сборник
    RAISE NOTICE '8. Треки без сборников: % (допустимо)',
        (SELECT COUNT(*) FROM track t 
         LEFT JOIN track_collection tc ON t.track_id = tc.track_id 
         WHERE tc.track_id IS NULL);
    
    -- 9. Проверка сборников без треков
    RAISE NOTICE '9. Сборники без треков: % (должно быть: 0)',
        (SELECT COUNT(*) FROM collection c 
         LEFT JOIN track_collection tc ON c.collection_id = tc.collection_id 
         WHERE tc.collection_id IS NULL);
    
    RAISE NOTICE '';
    RAISE NOTICE '=== ИТОГ ===';
    
    IF (SELECT COUNT(*) FROM artist) >= 4 AND
       (SELECT COUNT(*) FROM genre) >= 3 AND
       (SELECT COUNT(*) FROM album) >= 3 AND
       (SELECT COUNT(*) FROM track) >= 6 AND
       (SELECT COUNT(*) FROM collection) >= 4 AND
       (SELECT COUNT(*) FROM artist a LEFT JOIN artist_genre ag ON a.artist_id = ag.artist_id WHERE ag.artist_id IS NULL) = 0 AND
       (SELECT COUNT(*) FROM album al LEFT JOIN artist_album aa ON al.album_id = aa.album_id WHERE aa.album_id IS NULL) = 0 AND
       (SELECT COUNT(*) FROM collection c LEFT JOIN track_collection tc ON c.collection_id = tc.collection_id WHERE tc.collection_id IS NULL) = 0
    THEN
        RAISE NOTICE '✅ ВСЕ ТРЕБОВАНИЯ ВЫПОЛНЕНЫ!';
    ELSE
        RAISE NOTICE '❌ НЕ ВСЕ ТРЕБОВАНИЯ ВЫПОЛНЕНЫ';
    END IF;
END $$;