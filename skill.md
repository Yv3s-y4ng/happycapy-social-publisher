---
name: happycapy-social-publisher
description: HappyCapy-specific skill for publishing content to 13+ social media platforms (Instagram, Twitter, LinkedIn, Threads, Facebook, TikTok, YouTube, Pinterest, Reddit, Telegram, Discord, etc.) simultaneously with platform-optimized styles, optional AI-generated media (video/image), and smart error handling. Uses Late MCP integration available in HappyCapy environment. Use when you need to cross-post to social media, create multi-platform marketing content, share announcements across platforms, publish with platform-specific adaptations, generate AI media for posts, or manage social media publishing workflows. Supports interactive content creation with user-guided platform selection, media generation choices, preview before publish, and automatic retry with character limit adjustments.
---

# HappyCapy Social Media Publisher

Publish content to 13+ social media platforms with platform-optimized styles, optional AI-generated media, and smart error handling.

## Prerequisites Check

### 1. Check Late MCP Configuration

Read `~/.mcp.json` to verify Late MCP is configured with API key.

**If Late MCP not configured**, guide user through complete setup:

### Late API Setup (Complete in One Go)

Guide user to complete all steps together:

**1. Register and Get API Key**
- Visit https://getlate.dev and register (free tier: 20 posts/month)
- Go to Settings → API Keys
- Create API key (format: `sk_xxxxxxxxxxxxxxxx`)
- Keep this key ready for configuration

**2. Connect Social Media Accounts**
- In Late Dashboard → Accounts → Connect Account
- Connect desired platforms (13+ supported):
  - **LinkedIn**: Direct OAuth
  - **X/Twitter**: Direct OAuth
  - **Instagram**: Switch to Professional/Creator account, authorize via Facebook
  - **Threads**: Connect via Instagram account
  - **Facebook, TikTok, YouTube, Pinterest, Reddit, Telegram, Discord, etc.**

**3. Install uv (if not installed)**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Verify: `uvx --version`

**4. Configure ~/.mcp.json**
Edit `~/.mcp.json`, add `late` entry with the API key from step 1:

```json
{
  "mcpServers": {
    "late": {
      "command": "/home/node/.local/bin/uvx",
      "args": ["--from", "late-sdk[mcp]", "late-mcp"],
      "env": {
        "LATE_API_KEY": "sk_your_api_key_here"
      }
    }
  }
}
```

**5. Enable in ~/.claude/settings.local.json**
Add `"late"` to `enabledMcpjsonServers`:

```json
{
  "enabledMcpjsonServers": ["email", "late"]
}
```

**6. Start New Conversation**
Start a new conversation in HappyCapy for MCP tools to load.

### 2. Verify Connected Platforms

Use Late MCP to list connected accounts:

```
Call mcp__late__accounts_list
```

This returns list of connected platforms with profile IDs. If no accounts found, guide user to connect platforms at https://getlate.dev/accounts.

## Workflow

### Step 1: Analyze Content

Extract from user's input:
- **Core message**: Main topic or announcement
- **Key points**: 3-5 bullet points to emphasize
- **Tone**: Professional, casual, inspiring, technical, etc.
- **Call-to-action**: Link, question, or engagement prompt
- **Media suggestion**: Does content benefit from video or image?

### Step 2: Platform Selection

Show user their connected platforms from `accounts_list` result.

Late API supports 13+ platforms including:
- Instagram, Twitter/X, LinkedIn, Threads
- Facebook, TikTok, YouTube, Pinterest
- Reddit, Telegram, Discord, Mastodon
- And more

Display the platforms that the user has actually connected (from `accounts_list`).

Ask user to select which platforms to publish to:
- List all their connected platforms dynamically
- Allow selecting all or specific subset
- Explain any platform-specific requirements if needed

### Step 3: Media Generation (Optional)

Ask user if they want AI-generated media:

**Option A: Generate AI Video**
- Use `/generate-video` skill with appropriate prompt
- Duration: 6-8 seconds (optimal for social media)
- Save to `./outputs/` directory
- Get video URL for publishing

**Option B: Generate AI Image**
- Use `/generate-image` skill
- Save to `./outputs/` directory
- Get image URL for publishing

**Option C: User Upload**
- Ask user to provide media URL or file path

**Option D: Text Only**
- Proceed without media

### Step 4: Content Adaptation

Generate platform-specific versions of content following these guidelines:

**Instagram** (max 2,200 chars):
- Visual storytelling style
- Emoji-rich, engaging narrative
- 8 relevant hashtags (mix popular + niche)
- Emphasize visual elements

**Twitter** (max 280 chars):
- Concise and punchy
- Conversational tone
- 1-2 hashtags only
- Strong opening hook

**LinkedIn** (max 3,000 chars):
- Professional insights and analysis
- Value-driven content
- 3-5 industry hashtags
- Thought leadership angle

**Threads** (max 500 chars - STRICT):
- Casual, authentic story
- Personal touch and relatability
- NO hashtags (they don't work on Threads)
- Keep under 450 chars for safety buffer

**For detailed platform strategies**, see [references/platform-styles.md](references/platform-styles.md)

### Step 5: Preview & Approval

Display all generated content to user:

```markdown
## Preview

### Instagram (348 chars)
[content]

### Twitter (276 chars)
[content]

### LinkedIn (689 chars)
[content]

### Threads (413 chars)
[content]
```

Ask user:
1. Approve all and publish?
2. Edit specific platform content?
3. Cancel?

If user requests edits, modify specific platform content and re-preview.

### Step 6: Publish

Once approved, publish to selected platforms:

**For multiple platforms simultaneously:**
```
Call mcp__late__posts_cross_post with:
{
  "profiles": ["profile_id_1", "profile_id_2", ...],
  "text": "platform-specific content",
  "media_urls": ["https://...video.mp4"] (if media exists)
}
```

**For single platform:**
```
Call mcp__late__posts_create with:
{
  "profile_id": "specific_profile_id",
  "text": "content",
  "media_urls": ["..."] (optional)
}
```

### Step 7: Error Handling

**Threads Character Limit Error:**

If Threads post fails with "text too long" error:

1. **First retry**: Remove adjectives, condense sentences (target: 400 chars)
2. **Second retry**: Remove line breaks, simplify further (target: 350 chars)
3. **Third retry**: Rewrite to essential message only (target: 300 chars)
4. **Manual fallback**: Ask user to manually edit content

Each retry should maintain core message while shortening length.

**Other Platform Errors:**
- Media upload failures: Retry once, then fallback to text-only
- Rate limits: Show error, suggest trying again later
- Authentication errors: Guide user to reconnect platform at https://getlate.dev/accounts

### Step 8: Results Report

After publishing, show results:

```markdown
## Publishing Results

✅ Instagram: Posted successfully
   → https://instagram.com/p/xxxxx

✅ Twitter: Posted successfully
   → https://twitter.com/user/status/xxxxx

✅ LinkedIn: Posted successfully
   → https://linkedin.com/feed/update/xxxxx

⚠️ Threads: Failed (text too long)
   → Retrying with shortened content...
   → ✅ Posted on second attempt
```

Save results to `./outputs/{timestamp}_report.json` for reference.

## MCP Tools Reference

### List Connected Accounts
```
mcp__late__accounts_list
```

Returns array of connected platforms with:
- `id`: Profile ID for publishing
- `platform`: instagram, twitter, linkedin, threads
- `username`: Account username/handle

### Create Single Post
```
mcp__late__posts_create({
  "profile_id": "prof_xxx",
  "text": "Post content here",
  "media_urls": ["https://..."] (optional)
})
```

### Cross-Post to Multiple Platforms
```
mcp__late__posts_cross_post({
  "profiles": ["prof_1", "prof_2", "prof_3"],
  "text": "Content for all platforms",
  "media_urls": ["https://..."] (optional)
})
```

### Check Post Status
```
mcp__late__posts_get({
  "post_id": "post_xxx"
})
```

Returns post status: `pending`, `published`, `failed`

### Upload Media
```
mcp__late__media_generate_upload_link({
  "filename": "video.mp4"
})
```

Returns upload URL. After uploading, get media URL for publishing.

## Best Practices

### Character Count Guidelines

Always count characters INCLUDING:
- Newlines (`\n` = 1 char)
- Spaces
- Punctuation
- Emojis (some count as 2 chars)

For Threads, aim for **400-450 chars** to provide safety buffer.

### Content Adaptation Strategy

1. **Maintain core message** across all platforms
2. **Adapt style and tone** to platform culture
3. **Adjust length** to platform limits
4. **Use platform-appropriate hashtags**
5. **Keep authentic voice** (avoid AI clichés)

### Hashtag Strategy

- **Instagram**: 8 hashtags (mix trending + niche)
- **Twitter**: 1-2 hashtags max
- **LinkedIn**: 3-5 professional hashtags
- **Threads**: 0 hashtags (they don't function)

### Media Recommendations

- **Video**: 6-8 seconds, 16:9 ratio, under 100MB
- **Image**: 1080x1080px (square) or 1080x1350px (portrait)
- **Multiple platforms**: Use MP4 video or JPG/PNG images

## Common Pitfalls

❌ **Threads posts >500 chars** - Always fails
✅ Keep under 450 chars with buffer

❌ **Same content for all platforms** - Low engagement
✅ Adapt style and hashtags per platform

❌ **AI writing tells** - "Excited to announce", "Dive deep"
✅ Natural, conversational language

❌ **Too many hashtags on Twitter** - Looks spammy
✅ 1-2 relevant hashtags maximum

❌ **Using hashtags on Threads** - They don't work
✅ No hashtags on Threads

## Examples

### Product Launch Example

**User Input:**
"Launched HappyCapy - cloud-native AI platform. No more local setup!"

**Instagram (348 chars):**
```
🚀 从养claw到养capy的进化！

有点点生物背景的我突然意识到：这不就像从甲壳类进化到哺乳类吗？

Claw = 需要硬件、本地部署、不安全
Capy = 云端运行、零部署、更安全

HappyCapy 让一切变简单，告别本地配置的痛苦！

✨ 30万+ AI能力组合
☁️ 云端一键启动
🔒 更安全的环境

#AI工具 #云端开发 #HappyCapy #开发者工具 #AI平台 #CloudNative #NoCode #进化
```

**Twitter (276 chars):**
```
从养claw到养capy！🦞→🐹

有点点生物背景的我发现：Claw需要硬件+本地部署，Capy云端运行零配置。就像从甲壳类进化到哺乳类！

HappyCapy = 30万+ AI能力，云端一键启动 ☁️

告别配置地狱！

#AI #CloudDev
```

**LinkedIn (689 chars):**
```
From "养claw" to "养capy": An Evolution in AI Development Tools

As someone with a bit of biology background, I realized something interesting: the shift from Claude Code (Claw) to HappyCapy mirrors biological evolution - from crustaceans to mammals.

Key differences:
• Claw: Hardware-dependent, local deployment, security concerns
• Capy: Cloud-native, zero setup, enhanced security

Why this matters for developers:
✓ 300,000+ AI capability combinations
✓ Instant cloud deployment
✓ No local environment configuration
✓ Safer execution environment

The local-first approach is evolving. Just as mammals adapted better to diverse environments than crustaceans, cloud-native platforms offer flexibility and safety that hardware-dependent tools can't match.

Ready to evolve your development workflow?

#AITools #CloudDevelopment #DeveloperExperience #CloudNative #AIplatform
```

**Threads (413 chars):**
```
从养claw到养capy的感悟 🦞→🐹

有点点生物背景的我突然发现：这简直就是从甲壳类到哺乳类的进化啊！

Claw时代：需要硬件、本地部署、各种配置头疼
Capy时代：云端运行、零部署、打开就用

就像生物进化一样，哺乳类比甲壳类更高级，云端工具也比本地工具更方便更安全。

HappyCapy = 30万+ AI能力，告别配置地狱 ☁️

你还在养claw吗？
```

## Troubleshooting

### Late MCP Not Loading

1. Verify `~/.mcp.json` configuration is correct
2. Check API key format: `sk_xxxxxxxxxxxxxxxx`
3. Verify `uvx` is installed: `uvx --version`
4. Start a new conversation in HappyCapy
5. Check `~/.claude/settings.local.json` has `"late"` in `enabledMcpjsonServers`

### No Connected Accounts

1. Visit https://getlate.dev/accounts
2. Click "Connect Account" for each platform
3. Complete OAuth authorization
4. Wait for connection confirmation
5. Verify with `mcp__late__accounts_list`

### Media Upload Failures

1. Verify media URL is publicly accessible
2. Check file size (under 100MB for video)
3. Verify format: MP4 for video, JPG/PNG for images
4. Try uploading directly via `mcp__late__media_generate_upload_link`

### Threads Character Limit

Always count characters including newlines. Use auto-retry logic:
- Retry 1: Remove adjectives (target 400 chars)
- Retry 2: Condense sentences (target 350 chars)
- Retry 3: Essential message only (target 300 chars)

## Support

For configuration issues:
1. Check Late API dashboard: https://getlate.dev
2. Verify MCP configuration in `~/.mcp.json`
3. Review error messages from MCP tools
4. Check platform-specific requirements in references/
