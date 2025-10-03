# Running a Local LLM with Your Documents on MacBook Pro (2023, 32GB RAM)

## Overview

Your M2/M3 MacBook Pro with 32GB unified memory is excellent for running local LLMs. The unified memory architecture works particularly well for AI workloads.

This guide uses **Ollama** for running models and **Open WebUI** for a user-friendly interface to chat with your documents.

## Recommended Models for Your Hardware

- **Llama 3.1 8B** - Fast, great quality (uses ~8GB RAM) - **Start here**
- **Llama 3.1 70B** - Slower but very capable (uses ~40GB, will use swap but still runs)
- **Mistral 7B** - Good alternative, efficient
- **Qwen 2.5 14B** - Sweet spot for your RAM

The number (8B, 7B, etc.) indicates parameters - smaller = less RAM needed but less capable.

## Prerequisites

- macOS (your 2023 MacBook Pro)
- Docker Desktop for Mac (download from https://www.docker.com/products/docker-desktop)
- Homebrew (install from https://brew.sh if you don't have it)

## Installation

### Step 1: Install Ollama

```bash
brew install ollama
```

### Step 2: Start Ollama Server

```bash
ollama serve
```

Leave this terminal window running. Ollama needs to be running in the background.

### Step 3: Pull a Model

Open a new terminal window and run:

```bash
# Start with the 8B model (recommended)
ollama pull llama3.1:8b

# Or try other models:
# ollama pull mistral:7b
# ollama pull qwen2.5:14b
# ollama pull llama3.1:70b
```

### Step 4: Install Open WebUI

Make sure Docker Desktop is running, then:

```bash
docker run -d -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui \
  ghcr.io/open-webui/open-webui:main
```

## Using Open WebUI

### Step 1: Access the Interface

1. Open your browser and go to `http://localhost:3000`
2. Create an account (stored locally only - no internet required)

### Step 2: Upload Your Documents

1. Click on your profile icon or settings
2. Navigate to "Documents" or "Knowledge"
3. Upload your files (PDFs, text files, markdown, Word docs, etc.)
4. Wait for processing to complete

### Step 3: Chat with Your Documents

1. Start a new chat
2. Reference your uploaded documents in your questions
3. The model will use your documents to answer questions

## Understanding RAG (Retrieval Augmented Generation)

When you upload documents to Open WebUI, it uses RAG:

1. Your documents are split into chunks
2. Chunks are converted to embeddings (vectors)
3. When you ask a question, relevant chunks are retrieved
4. The LLM generates an answer using those chunks as context

This means:
- Your documents stay local on your machine
- No training required (fast setup)
- Works with any documents
- Can update documents anytime
- Completely private and offline

## Useful Ollama Commands

```bash
# List installed models
ollama list

# Remove a model
ollama rm llama3.1:8b

# Run a model directly in terminal (for testing)
ollama run llama3.1:8b

# Pull a specific version
ollama pull llama3.1:8b-instruct-q4_0

# Check running models
ollama ps
```

## Managing Open WebUI

```bash
# Stop Open WebUI
docker stop open-webui

# Start Open WebUI again
docker start open-webui

# View logs
docker logs open-webui

# Remove Open WebUI (keeps data)
docker rm open-webui

# Remove Open WebUI and data
docker rm open-webui
docker volume rm open-webui
```

## Tips for Best Performance

1. **Start with 8B models** - they run fast and are surprisingly capable
2. **Close memory-intensive apps** when running larger models (70B)
3. **First response may be slow** as models load into memory
4. **Subsequent responses will be faster** - models stay loaded
5. **Your Mac's fans may spin up** during inference, especially with larger models
6. **Use smaller models for quick tasks** and larger models for complex reasoning

## Troubleshooting

### Ollama not connecting to Open WebUI

Make sure:
- Ollama is running (`ollama serve`)
- You're using `host.docker.internal` in the Docker command
- Port 11434 (Ollama's port) isn't blocked

### Model running slow

- Try a smaller model (8B instead of 70B)
- Close other applications
- Check Activity Monitor for memory pressure

### Docker issues

- Make sure Docker Desktop is running
- Check Docker has enough resources allocated (Settings → Resources)
- Try restarting Docker Desktop

## Privacy Benefits

This setup:
- Runs completely offline after initial model download
- Keeps your documents on your machine
- Sends no data to external servers
- Gives you full control over your data
- No API keys or subscriptions needed

## Next Steps

1. Install Ollama and Docker Desktop
2. Download Llama 3.1 8B model
3. Start Open WebUI
4. Upload a few test documents
5. Ask questions about your documents
6. Experiment with different models to find your preference

## Additional Resources

- Ollama Documentation: https://github.com/ollama/ollama
- Open WebUI Documentation: https://docs.openwebui.com
- Available Models: https://ollama.com/library
