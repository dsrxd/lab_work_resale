#!/bin/bash

# Скрипт для автоматической генерации артефактов проектирования

# Переменные
PLANTUML_JAR="/home/ubuntu/plantuml.jar"
DIAGRAMS_DIR="docs/c4-diagrams"

# Проверка наличия plantuml.jar
if [ ! -f "$PLANTUML_JAR" ]; then
    echo "Ошибка: Файл plantuml.jar не найден по пути $PLANTUML_JAR"
    echo "Пожалуйста, скачайте его с официального сайта PlantUML."
    exit 1
fi

# Создание директории для диаграмм, если она не существует
mkdir -p $DIAGRAMS_DIR

# Генерация диаграмм из файлов .puml
echo "Генерация диаграмм из PlantUML файлов..."
java -jar $PLANTUML_JAR "$DIAGRAMS_DIR/*.puml" -o "$DIAGRAMS_DIR"

if [ $? -eq 0 ]; then
    echo "Диаграммы успешно сгенерированы в директорию $DIAGRAMS_DIR."
else
    echo "Ошибка при генерации диаграмм."
    exit 1
fi

# Копирование других артефактов (для полноты, хотя они уже на месте)
echo "Проверка наличия других артефактов..."
cp structurizr/model.dsl docs/
cp api-specification/openapi.yaml docs/

echo "Процесс сборки документации завершен."
