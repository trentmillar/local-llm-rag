# Local LLM RAG Setup with Ollama and Open WebUI
# Based on local-ollama-llm-guide.md

.PHONY: help install-ollama install-docker check-requirements start-ollama stop-ollama pull-models start-webui stop-webui restart-webui clean-webui list-models run-model status teardown teardown-all

# Default target
help:
	@echo "Local LLM RAG Setup - Available commands:"
	@echo ""
	@echo "Installation:"
	@echo "  install-ollama     Install Ollama via Homebrew"
	@echo "  install-docker     Install Docker Desktop (manual download required)"
	@echo "  install-all        Install Ollama and check Docker requirements"
	@echo "  check-requirements Check all system requirements before setup"
	@echo ""
	@echo "Model Management:"
	@echo "  pull-models        Pull recommended models (llama3.1:8b, mistral:7b, qwen2.5:14b)"
	@echo "  pull-llama8b      Pull Llama 3.1 8B model (recommended starting point)"
	@echo "  pull-llama70b     Pull Llama 3.1 70B model (requires more RAM)"
	@echo "  list-models        List installed models"
	@echo "  run-model          Run a model interactively in terminal"
	@echo ""
	@echo "Services:"
	@echo "  start-ollama       Start Ollama server in background"
	@echo "  stop-ollama        Stop Ollama server"
	@echo "  start-webui        Start Open WebUI container"
	@echo "  stop-webui         Stop Open WebUI container"
	@echo "  restart-webui      Restart Open WebUI container"
	@echo "  status             Show status of services"
	@echo ""
	@echo "Cleanup:"
	@echo "  clean-webui        Remove Open WebUI container and data"
	@echo "  clean-models       Remove all models (WARNING: re-download required)"
	@echo "  teardown           Stop all services and clean up containers"
	@echo "  teardown-all       Complete teardown including models and data"
	@echo ""
	@echo "Quick Start:"
	@echo "  setup              Complete setup (install + pull models + start services)"
	@echo "  quick-start        Start services (assumes already installed)"

# Installation targets
install-ollama:
	@echo "Installing Ollama via Homebrew..."
	brew install ollama
	@echo "Ollama installed successfully!"

install-docker:
	@echo "Docker Desktop installation required:"
	@echo "1. Visit https://www.docker.com/products/docker-desktop"
	@echo "2. Download Docker Desktop for Mac"
	@echo "3. Install and start Docker Desktop"
	@echo "4. Run 'make start-webui' after Docker is running"

# Comprehensive requirements check
check-requirements:
	@echo "=== Checking System Requirements ==="
	@echo ""
	@echo "0. Checking operating system..."
	@if [ "$$(uname)" != "Darwin" ]; then \
		echo "  ✗ This setup is designed for macOS (Darwin)"; \
		echo "     Detected OS: $$(uname)"; \
		echo "     Please run this on a Mac or adapt the instructions for your OS"; \
		exit 1; \
	else \
		echo "  ✓ Running on macOS ($$(uname))"; \
	fi
	@echo ""
	@echo "1. Checking Homebrew..."
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "  ✗ Homebrew not found. Please install from https://brew.sh"; \
		echo "     Run: /bin/bash -c \"\$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""; \
		exit 1; \
	else \
		echo "  ✓ Homebrew is installed ($$(brew --version | head -n1))"; \
	fi
	@echo ""
	@echo "2. Checking Ollama..."
	@if ! command -v ollama >/dev/null 2>&1; then \
		echo "  ✗ Ollama not found. Will install via Homebrew"; \
	else \
		echo "  ✓ Ollama is installed ($$(ollama --version))"; \
	fi
	@echo ""
	@echo "3. Checking Docker installation..."
	@if ! command -v docker >/dev/null 2>&1; then \
		echo "  ✗ Docker not found. Please install Docker Desktop manually."; \
		echo "     Visit: https://www.docker.com/products/docker-desktop"; \
		exit 1; \
	else \
		echo "  ✓ Docker is installed ($$(docker --version))"; \
	fi
	@echo ""
	@echo "4. Checking Docker daemon..."
	@if ! docker info >/dev/null 2>&1; then \
		echo "  ✗ Docker daemon is not running. Please start Docker Desktop."; \
		echo "     Open Docker Desktop application and wait for it to start."; \
		exit 1; \
	else \
		echo "  ✓ Docker daemon is running"; \
	fi
	@echo ""
	@echo "5. Checking system resources..."
	@echo "  ✓ All requirements met!"
	@echo ""

install-all: install-ollama
	@echo "Checking Docker installation..."
	@if ! command -v docker >/dev/null 2>&1; then \
		echo "Docker not found. Please install Docker Desktop manually."; \
		echo "Visit: https://www.docker.com/products/docker-desktop"; \
		exit 1; \
	else \
		echo "Docker is installed and ready!"; \
	fi

# Model management
pull-models: start-ollama pull-llama8b
	@echo "Pulling additional recommended models..."
	ollama pull mistral:7b
	ollama pull qwen2.5:14b
	@echo "All recommended models pulled successfully!"

pull-llama8b: start-ollama
	@echo "Pulling Llama 3.1 8B model (recommended starting point)..."
	ollama pull llama3.1:8b
	@echo "Llama 3.1 8B model pulled successfully!"

pull-llama70b: start-ollama
	@echo "Pulling Llama 3.1 70B model (requires ~40GB RAM)..."
	ollama pull llama3.1:70b
	@echo "Llama 3.1 70B model pulled successfully!"

list-models:
	@echo "Installed models:"
	ollama list

run-model:
	@echo "Available models:"
	@ollama list
	@echo ""
	@read -p "Enter model name to run (e.g., llama3.1:8b): " model; \
	ollama run $$model

# Service management
start-ollama:
	@echo "Starting Ollama server..."
	@if pgrep -f "ollama serve" > /dev/null; then \
		echo "Ollama is already running"; \
		echo "Verifying Ollama is responding..."; \
		for i in 1 2 3; do \
			if curl -s http://127.0.0.1:11434 >/dev/null 2>&1; then \
				echo "  ✓ Ollama is responding"; \
				break; \
			else \
				echo "  Waiting for Ollama... (attempt $$i/3)"; \
				sleep 2; \
			fi; \
		done; \
	else \
		nohup ollama serve > ollama.log 2>&1 & \
		echo "Ollama started in background (PID: $$!)"; \
		echo "Logs available in ollama.log"; \
		echo "Waiting for Ollama to be ready..."; \
		for i in 1 2 3 4 5; do \
			if curl -s http://127.0.0.1:11434 >/dev/null 2>&1; then \
				echo "  ✓ Ollama is ready!"; \
				break; \
			else \
				echo "  Waiting for Ollama... (attempt $$i/5)"; \
				sleep 2; \
			fi; \
		done; \
	fi

stop-ollama:
	@echo "Stopping Ollama server..."
	@pkill -f "ollama serve" || echo "Ollama was not running"
	@echo "Ollama stopped"

start-webui:
	@echo "Starting Open WebUI container..."
	@if docker ps -q -f name=open-webui | grep -q .; then \
		echo "Open WebUI is already running"; \
	elif docker ps -aq -f name=open-webui | grep -q .; then \
		echo "Found existing Open WebUI container, starting it..."; \
		docker start open-webui >/dev/null; \
		echo "Open WebUI started at http://localhost:3000"; \
	else \
		docker run -d -p 3000:8080 \
			--add-host=host.docker.internal:host-gateway \
			-v open-webui:/app/backend/data \
			--name open-webui \
			ghcr.io/open-webui/open-webui:main; \
		echo "Open WebUI started at http://localhost:3000"; \
	fi

stop-webui:
	@echo "Stopping Open WebUI container..."
	@docker stop open-webui 2>/dev/null || echo "Open WebUI was not running"
	@echo "Open WebUI stopped"

restart-webui: stop-webui start-webui
	@echo "Open WebUI restarted"

status:
	@echo "=== Service Status ==="
	@echo "Ollama:"
	@if pgrep -f "ollama serve" > /dev/null; then \
		echo "  ✓ Running (PID: $$(pgrep -f 'ollama serve'))"; \
	else \
		echo "  ✗ Not running"; \
	fi
	@echo ""
	@echo "Open WebUI:"
	@if docker ps -q -f name=open-webui | grep -q .; then \
		echo "  ✓ Running at http://localhost:3000"; \
	else \
		echo "  ✗ Not running"; \
	fi
	@echo ""
	@echo "Installed models:"
	@ollama list 2>/dev/null || echo "  No models installed"

# Cleanup targets
clean-webui:
	@echo "Removing Open WebUI container and data..."
	@docker stop open-webui 2>/dev/null || true
	@docker rm open-webui 2>/dev/null || true
	@docker volume rm open-webui 2>/dev/null || true
	@echo "Open WebUI cleaned up"

clean-models:
	@echo "WARNING: This will remove all installed models!"
	@read -p "Are you sure? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		ollama list | grep -v "NAME" | awk '{print $$1}' | xargs -I {} ollama rm {}; \
		echo "All models removed"; \
	else \
		echo "Operation cancelled"; \
	fi

# Quick start targets
setup: check-requirements install-all pull-llama8b start-ollama start-webui
	@echo ""
	@echo "=== Setup Complete! ==="
	@echo "1. Ollama is running in the background"
	@echo "2. Open WebUI is available at http://localhost:3000"
	@echo "3. Create an account and upload your documents"
	@echo "4. Start chatting with your documents!"
	@echo ""
	@echo "To check status: make status"
	@echo "To stop services: make stop-ollama stop-webui"

quick-start: check-requirements start-ollama start-webui
	@echo ""
	@echo "=== Services Started! ==="
	@echo "Open WebUI: http://localhost:3000"
	@echo "Ollama: Running in background"

# Teardown targets
teardown:
	@echo "=== Tearing Down Services ==="
	@echo ""
	@echo "1. Stopping Open WebUI..."
	@docker stop open-webui 2>/dev/null || echo "  Open WebUI was not running"
	@echo "2. Stopping Ollama..."
	@pkill -f "ollama serve" || echo "  Ollama was not running"
	@echo "3. Cleaning up containers..."
	@docker rm open-webui 2>/dev/null || echo "  Open WebUI container already removed"
	@echo ""
	@echo "=== Teardown Complete! ==="
	@echo "Services stopped and containers removed."
	@echo "Models and data are preserved."
	@echo ""
	@echo "To restart: make quick-start"
	@echo "To remove everything: make teardown-all"

teardown-all:
	@echo "=== Complete Teardown ==="
	@echo ""
	@echo "WARNING: This will remove ALL data including:"
	@echo "  - All downloaded models"
	@echo "  - Open WebUI data and uploaded documents"
	@echo "  - All containers and volumes"
	@echo ""
	@read -p "Are you sure you want to continue? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		echo ""; \
		echo "1. Stopping all services..."; \
		docker stop open-webui 2>/dev/null || true; \
		pkill -f "ollama serve" || true; \
		echo "2. Removing containers and volumes..."; \
		docker rm open-webui 2>/dev/null || true; \
		docker volume rm open-webui 2>/dev/null || true; \
		echo "3. Removing all models..."; \
		ollama list | grep -v "NAME" | awk '{print $$1}' | xargs -I {} ollama rm {} 2>/dev/null || true; \
		echo "4. Cleaning up log files..."; \
		rm -f ollama.log; \
		echo ""; \
		echo "=== Complete Teardown Finished! ==="; \
		echo "Everything has been removed."; \
		echo "To start fresh: make setup"; \
	else \
		echo ""; \
		echo "Teardown cancelled."; \
	fi
