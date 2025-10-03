# Uncensored Ollama Models Guide

## Overview

This guide covers uncensored Ollama models and how censorship works when running LLMs locally. Understanding these concepts helps you choose the right model for your specific use case.

## What Are Uncensored Models?

Uncensored models are versions of language models that have had safety filters, alignment training, and content restrictions removed or minimized. They're designed to provide more open and unrestricted responses compared to their "censored" or "aligned" counterparts.

## Available Uncensored Models in Ollama

### Llama 2 Uncensored Variants

```bash
# 7B parameter version (faster, less memory)
ollama pull llama2-uncensored:7b

# 70B parameter version (more capable, needs more RAM)
ollama pull llama2-uncensored:70b
```

**Created by:** George Sung and Jarrad Hope  
**Best for:** General purpose tasks requiring open responses

### Wizard Models (by Eric Hartford)

```bash
# Wizard Vicuna Uncensored
ollama pull wizard-vicuna-uncensored:7b
ollama pull wizard-vicuna-uncensored:13b
ollama pull wizard-vicuna-uncensored:30b

# WizardLM Uncensored
ollama pull wizardlm-uncensored:13b
```

**Created by:** Eric Hartford  
**Best for:** Code generation, technical writing, creative tasks

### Other Uncensored Options

```bash
# Nous Hermes Llama 2 (known for long responses, lower hallucination)
ollama pull nous-hermes-llama2:13b

# Dolphin-Mistral (handles sensitive topics well)
ollama pull dolphin-mistral:7b
```

## Does Censorship Matter When Running Locally?

### Short Answer: It Depends on Your Use Case

When running models locally with Ollama, you have more control, but censorship still affects the model's behavior.

### Why Local Models Are Different

1. **No External Filtering**: No external service filters your requests or responses
2. **Full Control**: You can modify system prompts and model behavior
3. **Complete Privacy**: Your conversations never leave your machine
4. **No Rate Limits**: No external API restrictions or usage limits
5. **Offline Operation**: Works without internet after initial setup

### However, Censorship Still Matters Because

1. **Model Training**: Base models are trained with safety guidelines built-in
2. **System Prompts**: Many models have hardcoded safety instructions
3. **Alignment**: Models are "aligned" during training to avoid certain topics
4. **Inherent Behavior**: The model's core behavior is shaped by its training data

## When to Use Uncensored Models

### Good Use Cases for Uncensored Models

- **Creative Writing**: Fiction, poetry, storytelling without content restrictions
- **Research**: Analyzing controversial or sensitive topics
- **Technical Analysis**: Discussing security vulnerabilities, exploits, or edge cases
- **Educational Content**: Teaching about topics that might be flagged by censored models
- **Content Moderation**: Understanding what content might be problematic
- **Creative Problem Solving**: Brainstorming without artificial limitations

### When Regular Models Are Fine

- **Document Q&A**: Asking questions about your uploaded documents
- **General Research**: Most academic or professional topics
- **Code Help**: Programming assistance and debugging
- **Business Analysis**: Financial, marketing, or operational questions
- **Educational Content**: Learning about standard topics

## For Document RAG Use Cases

Since you're using these for document analysis and RAG (Retrieval Augmented Generation), **censorship is generally less of a concern** because:

- You're asking questions about your own documents
- Responses are based on factual content from your files
- You're not trying to generate controversial content
- The model is constrained by your document content

### Recommendation for RAG

1. **Start with regular models** like `llama3.1:8b` - they work excellently for document Q&A
2. **Try uncensored models** if you need more open-ended analysis or creative writing about your documents
3. **Consider your content**: If your documents contain sensitive topics, uncensored models might be more helpful

## Model Comparison for RAG

| Model Type | Best For | Memory Usage | Speed |
|------------|----------|--------------|-------|
| Regular Models | Standard document Q&A | Lower | Faster |
| Uncensored Models | Sensitive topics, creative analysis | Similar | Similar |
| Larger Models (70B) | Complex reasoning | Higher | Slower |
| Smaller Models (7B-8B) | Quick responses | Lower | Faster |

## Testing Different Models

You can easily test different models with Ollama:

```bash
# List installed models
ollama list

# Run a specific model
ollama run llama3.1:8b
ollama run llama2-uncensored:7b
ollama run wizard-vicuna-uncensored:13b

# Switch models in Open WebUI
# Just change the model selection in the interface
```

## Safety Considerations

### Important Notes

- **Uncensored models may generate inappropriate content** - use responsibly
- **Test with your specific documents first** - some content may trigger unexpected responses
- **Consider your audience** - don't use uncensored models for public-facing applications without review
- **Monitor outputs** - especially when processing sensitive documents

### Best Practices

1. **Start with regular models** for most use cases
2. **Test uncensored models** with a small subset of your documents first
3. **Use appropriate system prompts** to guide model behavior
4. **Review outputs** before sharing or acting on them
5. **Keep backups** of important documents before processing

## System Prompt Customization

You can influence model behavior with system prompts, even with uncensored models:

```bash
# Example system prompt for document analysis
ollama run llama2-uncensored:7b --system "You are a helpful research assistant. Analyze the provided documents objectively and provide detailed, factual responses based on the content."
```

## Performance Tips

- **Start with 7B-8B models** for testing uncensored variants
- **Use 13B models** for better quality if you have sufficient RAM
- **70B models** are overkill for most RAG tasks unless you need very high quality
- **Monitor memory usage** - uncensored models use similar resources to regular models

## Conclusion

For most document RAG use cases, regular models work perfectly fine. Uncensored models are useful when you need more open-ended analysis or when working with sensitive topics. The key is to test different models with your specific documents and use cases to find what works best for you.

Remember: running models locally gives you complete control and privacy, regardless of whether you choose censored or uncensored variants.
