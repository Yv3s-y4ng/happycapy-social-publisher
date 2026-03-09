---
name: cross-platform-publisher
description: Publish content to Instagram, Twitter, LinkedIn, and Threads simultaneously with platform-optimized styles, optional AI-generated media (video/image), and smart error handling. Use when you need to cross-post to social media, create multi-platform marketing content, share announcements across platforms, publish with platform-specific adaptations, generate AI media for posts, or manage social media publishing workflows. Supports interactive content creation with user-guided platform selection, media generation choices, preview before publish, and automatic retry with character limit adjustments (especially for Threads 500-char limit).
---

# Cross-Platform Social Media Publisher

Automatically publish content to Instagram, Twitter, LinkedIn, and Threads with platform-optimized styles, optional AI-generated media, and smart error handling.

## Features

✅ **Auto Setup** - Detects and configures Late MCP automatically
✅ **Smart Adaptation** - Extracts core message and adapts to each platform's style
✅ **AI Media** - Optional AI-generated videos/images via AI Gateway
✅ **Interactive Flow** - User-guided choices at each step
✅ **Error Handling** - Auto-retry with character limit adjustments
✅ **Preview & Control** - Review content before publishing

## Usage

### Basic Usage
```bash
/cross-post "Your announcement or content here"
```

The skill will guide you through:
1. Platform selection
2. Media generation options
3. Content preview
4. Publishing confirmation

### With Arguments (Optional)
```bash
# Specify platforms
/cross-post "Content" --platforms "instagram,twitter,linkedin"

# Request video generation
/cross-post "Content" --with-video

# Request image generation
/cross-post "Content" --with-image

# Save as draft instead of publishing
/cross-post "Content" --draft
```

## Requirements

### Late MCP (Auto-configured)
The skill will automatically:
1. Install Late MCP to global config (`~/.claude/mcp-servers/`)
2. Guide you to get API key: https://getlate.dev/settings/api-keys
3. Prompt you to connect platforms: https://getlate.dev/accounts

**Supported Platforms:**
- Instagram
- Twitter
- LinkedIn
- Threads

### AI Gateway (Optional)
For AI-generated media:
- Set environment variable: `AI_GATEWAY_API_KEY`
- Without this, you can still upload your own media

## How It Works

### Step 1: Content Analysis
Extracts core information from your input:
- Main topic/message
- Key selling points
- Emotional tone
- Call-to-action
- Suggested media type

### Step 2: Platform Selection
Shows your connected social accounts and lets you choose which platforms to publish to.

### Step 3: Media Generation (Optional)
User choices:
- Generate AI video
- Generate AI image
- Upload own media
- Text-only post

### Step 4: Content Adaptation
Generates platform-specific versions with unique styles and character limits:

- **Instagram**: Visual storytelling, emoji-rich, 8 hashtags (2,200 chars)
- **Twitter**: Concise and punchy, 2 hashtags (280 chars)
- **LinkedIn**: Professional insights, 5 hashtags (3,000 chars)
- **Threads**: Casual story, no hashtags (500 chars - strict)

**For detailed platform adaptation strategies**, see [references/platform-styles.md](references/platform-styles.md)

### Step 5: Preview & Publish
- Review all platform content
- Edit specific platforms if needed
- Publish to all selected platforms
- Real-time status updates

### Step 6: Results Report
- Success/failure status per platform
- Direct links to posts
- Saved files (video, content JSON, report)

## Platform Adaptation Strategy

Based on real-world experience, each platform gets:

1. **Same core message** - Key points maintained across all
2. **Platform-specific style** - Tone and structure adapted
3. **Character limits** - Strictly respected (with buffer for Threads)
4. **Smart hashtags** - Relevant tags for discovery
5. **Authentic voice** - Avoids "AI writing" feel

## Error Handling

### Automatic Recovery
- **Threads character limit**: Auto-shortens and retries up to 3 times
- **Media URL failures**: Falls back to text-only
- **Platform errors**: Retries with exponential backoff
- **Failed posts**: Option to save as draft

### Common Issues

**"Late MCP not configured"**
→ Skill auto-installs and guides setup

**"Text too long for Threads"**
→ Auto-shortens content and retries

**"Media generation failed"**
→ Offers to proceed without media or retry

**"AI Gateway not configured"**
→ Prompts to upload own media or skip

## Examples

### Product Launch
```bash
/cross-post "Launched HappyCapy - a cloud-native AI platform that makes everything easier. No more local setup headaches!"
```

**Result:** 4 platform-specific posts with evolution-themed video

### Blog Post Promotion
```bash
/cross-post "New blog post: Why AI tools are evolving from hardware-dependent to cloud-native. Read here: blog.com/post" --with-image
```

**Result:** Professional analysis on LinkedIn, casual take on Threads, visual story on Instagram

### Event Announcement
```bash
/cross-post "Join us for AI Summit 2026! March 15-17 in SF. Early bird tickets now available." --platforms "linkedin,twitter"
```

**Result:** Professional announcement on LinkedIn, punchy promo on Twitter

## Tips for Best Results

✅ **Be specific** - More context = better platform adaptations
✅ **Include benefits** - What's in it for the audience?
✅ **Add CTA** - Link or call-to-action
✅ **Let AI suggest** - Media type recommendations usually work well
✅ **Preview first** - Always review before publishing
✅ **Monitor engagement** - Check results in 24 hours

## Troubleshooting

### Late MCP Issues
```bash
# Check configuration
cat ~/.claude/mcp-servers/settings.json

# Verify API key is set
# Should see: "LATE_API_KEY": "your-key"

# Check connected accounts
# Visit: https://getlate.dev/accounts
```

### Media Generation Issues
```bash
# Check AI Gateway key
echo $AI_GATEWAY_API_KEY

# If not set, add to shell profile:
export AI_GATEWAY_API_KEY="your-key"
```

### Content Too Long
The skill auto-adjusts, but you can:
- Manually edit in preview step
- Let skill shorten automatically
- Remove optional details

## File Outputs

After publishing, find generated files in `./outputs/`:
- `{timestamp}_video.mp4` - Generated video (if created)
- `{timestamp}_content.json` - All platform content
- `{timestamp}_report.json` - Publishing results

## Advanced Usage

### Batch Publishing
Save content as drafts, review later:
```bash
/cross-post "Content 1" --draft
/cross-post "Content 2" --draft
/cross-post "Content 3" --draft
```

### Template Reuse
Save successful content patterns:
```bash
# After successful publish
# Copy from outputs/{timestamp}_content.json
# Edit and reuse structure
```

## Limitations

- Threads: Strict 500 character limit (including newlines)
- Twitter: 280 characters + media limitations
- LinkedIn: Video upload size limits
- Instagram: Requires business/creator account for API posting

## Privacy & Security

- API keys stored locally in `~/.claude/mcp-servers/`
- No content logged externally
- Media files saved to local `./outputs/` only
- Late MCP handles secure OAuth with platforms

## Support

For issues:
1. Check troubleshooting section above
2. Verify Late MCP config and platform connections
3. Review error messages in publishing report
