-- create_tables.sql
-- Создание таблиц для музыкального сервиса

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
CREATE INDEX idx_album_year ON Album(release_year);
CREATE INDEX idx_collection_year ON Collection(release_year);
CREATE INDEX idx_track_duration ON Track(duration);
CREATE INDEX idx_track_album ON Track(album_id);