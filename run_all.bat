```batch
@echo off
chcp 65001 > nul
echo ========================================
echo  ЗАПУСК СКРИПТОВ БАЗЫ ДАННЫХ
echo  Музыкальный сервис - PostgreSQL
echo ========================================
echo.

echo Шаг 1: Создание базы данных...
psql -U postgres -c "DROP DATABASE IF EXISTS music_service_db;" 2>nul
psql -U postgres -c "CREATE DATABASE music_service_db;" 2>nul
if errorlevel 1 (
    echo Ошибка: Не удалось создать базу данных
    echo Убедитесь, что:
    echo 1. PostgreSQL запущен
    echo 2. Пользователь postgres существует
    echo 3. У вас есть права на создание БД
    pause
    exit /b 1
)

echo.
echo Шаг 2: Создание таблиц...
psql -U postgres -d music_service_db -f create_tables.sql
if errorlevel 1 (
    echo Ошибка при создании таблиц
    pause
    exit /b 1
)

echo.
echo Шаг 3: Заполнение данными (Задание 1)...
psql -U postgres -d music_service_db -f insert_data.sql
if errorlevel 1 (
    echo Ошибка при заполнении данными
    pause
    exit /b 1
)

echo.
echo Шаг 4: Проверка требований...
psql -U postgres -d music_service_db -f check_all_requirements.sql

echo.
echo ========================================
echo  ВЫПОЛНЕНИЕ ЗАПРОСОВ
echo ========================================

echo.
echo Задание 2: Базовые SELECT-запросы...
echo -------------------------------------------------
psql -U postgres -d music_service_db -f select_queries.sql

echo.
echo Задание 3: Продвинутые SELECT-запросы...
echo -------------------------------------------------
psql -U postgres -d music_service_db -f advanced_queries.sql

echo.
echo Задание 4: Необязательные запросы...
echo -------------------------------------------------
psql -U postgres -d music_service_db -f optional_queries.sql

echo.
echo ========================================
echo  ВСЕ СКРИПТЫ ВЫПОЛНЕНЫ УСПЕШНО!
echo ========================================
echo.
echo База данных создана: music_service_db
echo.
echo Содержание базы:
echo - 9 исполнителей
echo - 11 жанров
echo - 16 альбомов
echo - 45 треков
echo - 10 сборников
echo.
pause