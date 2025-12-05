workspace "Система продажи и перепродажи билетов на футбол" "Онлайн-платформа для продажи билетов на футбольные матчи с возможностью перепродажи между пользователями" {

    model {
        # Актеры
        buyer = person "Покупатель" "Просматривает расписание футбольных матчей, покупает билеты от организатора и с перепродажи"
        seller = person "Продавец" "Владелец билета, который выставляет свои билеты на перепродажу другим пользователям"
        admin = person "Администратор" "Управляет расписанием матчей и инвентарем билетов"

        # Внешние системы
        paymentGateway = softwareSystem "Платежный шлюз" "Обрабатывает кредитные карты и платежи между пользователями" "external"
        emailService = softwareSystem "Сервис Email-уведомлений" "Отправляет подтверждения покупки, уведомления о перепродаже и другие сообщения" "external"
        matchDataProvider = softwareSystem "Поставщик данных о матчах" "Предоставляет расписание и информацию о футбольных матчах" "external"

        # Основная система
        ticketSystem = softwareSystem "Система продажи и перепродажи билетов на футбол" "Онлайн-платформа для продажи и перепродажи билетов на футбольные матчи" {
            
            # Контейнеры (C4 Level 2)
            webApp = container "Web Application" "Предоставляет пользовательский интерфейс для покупки и перепродажи билетов" "React SPA" "web"
            
            apiApp = container "API Application" "Предоставляет REST API для управления билетами, матчами и перепродажей" "Java Spring Boot" {
                
                # Компоненты (C4 Level 3)
                # Контроллеры
                ticketController = component "Ticket Controller" "Обрабатывает HTTP-запросы для операций с билетами" "Spring REST Controller"
                matchController = component "Match Controller" "Обрабатывает HTTP-запросы для получения информации о матчах" "Spring REST Controller"
                resaleController = component "Resale Controller" "Обрабатывает HTTP-запросы для перепродажи билетов" "Spring REST Controller"
                
                # Сервисы бизнес-логики
                userService = component "User Service" "Управляет пользователями и аутентификацией" "Spring Service"
                ticketService = component "Ticket Service" "Управляет жизненным циклом билетов" "Spring Service"
                matchService = component "Match Service" "Управляет информацией о матчах" "Spring Service"
                listingService = component "Listing Service" "Управляет объявлениями о перепродаже билетов" "Spring Service"
                resaleService = component "Resale Service" "Обрабатывает транзакции перепродажи между пользователями" "Spring Service"
                
                # Сервисы интеграции
                paymentService = component "Payment Service" "Интегрируется с платежным шлюзом для обработки платежей" "Spring Service"
                notificationService = component "Notification Service" "Отправляет уведомления пользователям" "Spring Service"
                matchDataService = component "Match Data Service" "Получает данные о матчах из внешнего источника" "Spring Service"
            }
            
            database = container "База данных" "Хранит информацию о пользователях, билетах, матчах и объявлениях о перепродаже" "MySQL" "database"
        }

        # Отношения между актерами и системами
        buyer -> ticketSystem "Просматривает матчи, покупает билеты от организатора и с перепродажи"
        seller -> ticketSystem "Выставляет свои билеты на перепродажу, управляет объявлениями"
        admin -> ticketSystem "Управляет расписанием и инвентарем"
        
        ticketSystem -> paymentGateway "Обрабатывает платежи через" "JSON/HTTPS"
        ticketSystem -> emailService "Отправляет уведомления через" "JSON/HTTPS"
        ticketSystem -> matchDataProvider "Получает данные о матчах через" "JSON/HTTPS"

        # Отношения между контейнерами
        buyer -> webApp "Использует" "HTTPS"
        seller -> webApp "Использует" "HTTPS"
        admin -> webApp "Использует" "HTTPS"
        
        webApp -> apiApp "Выполняет API-запросы к" "JSON/HTTPS"
        apiApp -> database "Читает и записывает данные в" "JDBC"
        apiApp -> paymentGateway "Обрабатывает платежи через" "JSON/HTTPS"
        apiApp -> emailService "Отправляет уведомления через" "JSON/HTTPS"
        apiApp -> matchDataProvider "Получает данные о матчах из" "JSON/HTTPS"

        # Отношения между компонентами (C4 Level 3)
        webApp -> ticketController "Выполняет API-запросы к" "JSON/HTTPS"
        webApp -> matchController "Выполняет API-запросы к" "JSON/HTTPS"
        webApp -> resaleController "Выполняет API-запросы к" "JSON/HTTPS"
        
        # Ticket Controller
        ticketController -> ticketService "Использует"
        ticketController -> userService "Использует"
        
        # Match Controller
        matchController -> matchService "Использует"
        
        # Resale Controller
        resaleController -> listingService "Использует"
        resaleController -> resaleService "Использует"
        resaleController -> userService "Использует"
        
        # Ticket Service
        ticketService -> database "Читает и записывает билеты в" "JDBC"
        ticketService -> paymentService "Использует для обработки платежей"
        ticketService -> notificationService "Использует для отправки уведомлений"
        
        # Match Service
        matchService -> database "Читает информацию о матчах из" "JDBC"
        matchService -> matchDataService "Получает данные о матчах из"
        
        # Listing Service
        listingService -> database "Читает и записывает объявления в" "JDBC"
        listingService -> ticketService "Проверяет владение билетом"
        listingService -> notificationService "Уведомляет о создании объявления"
        
        # Resale Service
        resaleService -> database "Обновляет данные о перепродаже в" "JDBC"
        resaleService -> ticketService "Обновляет владельца билета"
        resaleService -> listingService "Обновляет статус объявления"
        resaleService -> paymentService "Обрабатывает платеж между пользователями"
        resaleService -> notificationService "Уведомляет продавца и покупателя"
        
        # User Service
        userService -> database "Читает и записывает пользователей в" "JDBC"
        
        # Payment Service
        paymentService -> paymentGateway "Отправляет платежные запросы в" "JSON/HTTPS"
        
        # Notification Service
        notificationService -> emailService "Отправляет email через" "JSON/HTTPS"
        
        # Match Data Service
        matchDataService -> matchDataProvider "Получает данные из" "JSON/HTTPS"
    }

    views {
        # C4 Level 1: System Context
        systemContext ticketSystem "SystemContext" {
            include *
            autoLayout
        }

        # C4 Level 2: Container Diagram
        container ticketSystem "Containers" {
            include *
            autoLayout
        }

        # C4 Level 3: Component Diagram
        component apiApp "Components" {
            include *
            autoLayout
        }

        styles {
            element "Person" {
                shape person
                background #08427B
                color #ffffff
            }
            element "external" {
                background #999999
                color #ffffff
            }
            element "web" {
                shape WebBrowser
                background #438DD5
                color #ffffff
            }
            element "database" {
                shape Cylinder
                background #438DD5
                color #ffffff
            }
        }
    }
}
