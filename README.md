# Smart File Sharing & Collaboration App

A cross-platform mobile application built with **Flutter** and backed by a **Node.js/Express + MongoDB** server that enables users to upload, share, version-control, and collaboratively comment on files — with full offline support via **Hive**.

## Features

- 📁 **File Management** – Upload, view, and organize files (PDF, DOC, IMG, TXT)
- 🔄 **Version Control** – Track file versions with a visual timeline
- 💬 **Commenting** – Collaborate with threaded comments on each file
- 🔗 **Sharing** – Share files and view shared-with-you files
- 🔍 **Search & Filter** – Search by name, filter by type or shared status
- 📴 **Offline-First** – Full Hive-based local storage with online sync
- 🤖 **AI Summaries** – Claude AI integration for file summaries
- ⚡ **Conflict Resolution** – Automatic conflict detection and resolution

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter + Riverpod |
| Local DB | Hive |
| Backend | Node.js + Express |
| Database | MongoDB + Mongoose |
| AI | Claude API |

## Project Structure

```
lib/
├── main.dart & app.dart        # Entry point & routing
├── core/                       # Constants, utils, reusable widgets
├── models/                     # Hive-compatible data models
├── services/                   # Business logic (CRUD, sync, AI)
├── providers/                  # Riverpod state management
└── screens/                    # 5 UI screens with widgets

backend/
├── server.js                   # Express entry point
└── src/                        # Config, models, routes, controllers
```
