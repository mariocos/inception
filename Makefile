# Makefile for Inception project

# Variables
COMPOSE_FILE = docker-compose.yml
DATA_DIR = ./data
ENV_FILE = .env

# Default target
all: setup build up

# Create necessary directories
setup:
	@echo "Creating data directories..."
	mkdir -p $(DATA_DIR)/wordpress_data
	mkdir -p $(DATA_DIR)/mariadb_data
	@echo "Checking for .env file..."
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "Creating sample .env file..."; \
		echo "# MariaDB settings" > $(ENV_FILE); \
		echo "MARIA_ROOT_PW=rootpassword" >> $(ENV_FILE); \
		echo "WORDPRESS_DB=wordpress" >> $(ENV_FILE); \
		echo "DB_USER=wpuser" >> $(ENV_FILE); \
		echo "DB_USER_PWD=wppassword" >> $(ENV_FILE); \
		echo "DB_HOST=mariadb" >> $(ENV_FILE); \
		echo "NETWORK_NAME=my-network" >> $(ENV_FILE); \
		echo "" >> $(ENV_FILE); \
		echo "# WordPress settings" >> $(ENV_FILE); \
		echo "ADMIN_USER=wpadmin" >> $(ENV_FILE); \
		echo "ADMIN_PWD=wpadminpass" >> $(ENV_FILE); \
		echo "ADMIN_EMAIL=admin@example.com" >> $(ENV_FILE); \
		echo "WP_USER=user1" >> $(ENV_FILE); \
		echo "WP_USER_EMAIL=user1@example.com" >> $(ENV_FILE); \
		echo "WP_USER_PWD=user1pass" >> $(ENV_FILE); \
		echo "WARNING: Please change these default passwords!" >> $(ENV_FILE); \
		echo ".env file created. Please edit with secure passwords."; \
	fi

# Build all services
build:
	@echo "Building Docker images..."
	docker-compose -f $(COMPOSE_FILE) build

# Start all services
up:
	@echo "Starting services..."
	docker-compose -f $(COMPOSE_FILE) up -d

# Stop all services
down:
	@echo "Stopping services..."
	docker-compose -f $(COMPOSE_FILE) down

# Restart all services
restart: down up

# Show status of containers
status:
	@echo "Container status:"
	docker-compose -f $(COMPOSE_FILE) ps

# Show logs
logs:
	docker-compose -f $(COMPOSE_FILE) logs

# Follow logs
follow:
	docker-compose -f $(COMPOSE_FILE) logs -f

# Clean up (remove containers, images, volumes, networks)
clean: down
	@echo "Removing containers, images, and networks..."
	docker-compose -f $(COMPOSE_FILE) rm -f
	docker-compose -f $(COMPOSE_FILE) down --rmi all --remove-orphans

# Clean everything including data volumes
fclean: clean
	@echo "Removing data volumes..."
	rm -rf $(DATA_DIR)/*
	@echo "Complete cleanup done."

# Rebuild everything from scratch
re: fclean all

.PHONY: all setup build up down restart status logs follow clean fclean re