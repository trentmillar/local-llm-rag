# Running a Local LLM with Your Documents on Mac

## Overview

An M2 MacBook Pro with 32GB unified memory is excellent for running local LLMs. The unified memory architecture works particularly well for AI workloads.

## Recommended Models for Your Hardware

- **Llama 3.1 8B** - Fast, great quality (uses ~8GB RAM)
- **Llama 3.1 70B** - Slower but very capable (uses ~40GB, will use swap but still runs)
- **Mistral 7B** - Good alternative, efficient
- **Qwen 2.5 14B** - Sweet spot for your RAM

The number (8B, 7B, etc.) indicates parameters - smaller = less RAM needed but less capable.

## Option 1: Ollama + Open WebUI (Automated Setup)

This repository includes a Makefile that automates the entire setup process.

### Quick Start (Automated)

```bash
# Complete setup from scratch
make setup

# Or step by step:
make install-all    # Install Ollama and check Docker
make pull-llama8b   # Download recommended model
make start-ollama   # Start Ollama server
make start-webui    # Start Open WebUI interface
```

### Available Makefile Commands

**Installation:**
- `make install-ollama` - Install Ollama via Homebrew
- `make install-docker` - Instructions for Docker Desktop installation
- `make install-all` - Install Ollama and check Docker

**Model Management:**
- `make pull-models` - Pull all recommended models
- `make pull-llama8b` - Pull Llama 3.1 8B model (recommended)
- `make pull-llama70b` - Pull Llama 3.1 70B model (more capable)
- `make list-models` - Show installed models
- `make run-model` - Run a model interactively in terminal

**Service Management:**
- `make start-ollama` - Start Ollama server in background
- `make stop-ollama` - Stop Ollama server
- `make start-webui` - Start Open WebUI container
- `make stop-webui` - Stop Open WebUI container
- `make restart-webui` - Restart Open WebUI container
- `make status` - Check status of all services

**Quick Commands:**
- `make setup` - Complete setup (install + pull models + start services)
- `make quick-start` - Start services (assumes already installed)

**Cleanup:**
- `make clean-webui` - Remove Open WebUI container and data
- `make clean-models` - Remove all models (with confirmation)

### Manual Setup (Step by Step)

If you prefer manual installation:

#### Step 1: Install Ollama

```bash
brew install ollama
```

#### Step 2: Start Ollama and Pull a Model

```bash
# Start Ollama server
ollama serve

# In another terminal, pull a model
ollama pull llama3.1:8b
```

#### Step 3: Install Open WebUI

Requires Docker Desktop for Mac.

```bash
docker run -d -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui \
  ghcr.io/open-webui/open-webui:main
```

#### Step 4: Use It

1. Visit http://localhost:3000 in your browser
2. Create an account (local only)
3. Upload documents (PDFs, text files, etc.)
4. Chat with your documents using the model

## Option 2: LM Studio (GUI - Easiest)

### Step 1: Download LM Studio

Visit https://lmstudio.ai and download for Mac.

### Step 2: Download Models

1. Open LM Studio
2. Browse models in the GUI
3. Click download on your preferred model
4. Wait for download to complete

### Step 3: Upload Documents and Chat

1. Go to the Chat tab
2. Upload your documents using drag-and-drop
3. Start chatting with your documents

LM Studio is the easiest option for Mac - no terminal commands required.

## Option 3: AnythingLLM (All-in-One Solution)

Download from https://anythingllm.com

- Complete GUI application
- Built-in document management
- Works with Ollama or built-in models
- Privacy-focused

## Understanding RAG (Retrieval Augmented Generation)

When you upload documents to these tools, they're using RAG, not training:

1. Your documents are split into chunks
2. Chunks are converted to embeddings (vectors)
3. When you ask a question, relevant chunks are retrieved
4. The LLM generates an answer using those chunks as context

This means:

- Your documents stay local
- No training required (fast setup)
- Works with any documents
- Can update documents anytime

## Alternative Tools for Developers

If you want to build your own solution:

- **LangChain** - Python framework for LLM applications
- **LlamaIndex** - Specialized for document indexing and retrieval
- **PrivateGPT** - Privacy-focused document chat system

## Quick Comparison

| Tool | Difficulty | Best For |
|------|------------|----------|
| LM Studio | Easy | Beginners, GUI lovers |
| Ollama + Open WebUI | Medium | CLI comfortable users |
| AnythingLLM | Easy | All-in-one solution |
| LangChain/LlamaIndex | Hard | Developers building custom apps |

## Tips for Best Performance

- Start with 8B models to test - they run fast
- Close other memory-intensive apps when running larger models
- The first response may be slow as models load into memory
- Subsequent responses will be much faster
- Your Mac's fans may spin up during inference

## Recommended First Steps

### Using the Makefile (Recommended)
1. Run `make setup` for complete automated setup
2. Visit http://localhost:3000 and create an account
3. Upload a few test documents
4. Ask questions about your documents
5. Try different models with `make pull-llama70b` for more capability

### Manual Setup
1. Install LM Studio (easiest) or Ollama
2. Download Llama 3.1 8B model
3. Upload a few test documents
4. Ask questions about your documents
5. If satisfied, consider trying larger models like 14B or 70B

## Privacy Benefits

All of these solutions:

- Run completely offline after initial download
- Keep your documents on your machine
- Send no data to external servers
- Give you full control over your data
