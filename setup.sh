#!/bin/bash

# --- Check for Root Privileges ---
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script with sudo."
  exit
fi

# --- 1. Install System Packages ---
echo "⚙️ Installing packages (nodejs, npm, python3, pip, wget)..."
apt-get update
apt-get install -y nodejs npm python3 python3-pip wget
# For Fedora/CentOS, you would use: sudo dnf install nodejs npm python3 python3-pip wget

# --- 2. Add Environment Variables ---
echo "🔑 Adding environment variables to /etc/environment..."
# This makes variables available to all users system-wide after a reboot.
# Using tee to append with sudo privileges.
echo 'GANJAGURU_API_KEY="YOUR_API_KEY_HERE"' | tee -a /etc/environment
echo 'NODE_ENV="development"' | tee -a /etc/environment

# --- 3. Create Project Structure in Root ---
PROJECT_ROOT="/ganjaguru"
echo "📂 Creating project structure in $PROJECT_ROOT..."
mkdir -p $PROJECT_ROOT

# Create all subdirectories and empty files with sudo
{
  cd $PROJECT_ROOT
  touch .env .gitignore README.md package.json
  mkdir -p data/raw data/processed data/external src/model src/routes src/services src/utils public/css public/js public/img models tests docs
  touch src/intents.json src/faq_corpus.txt src/training_script.py
  touch public/index.html public/css/styles.css public/js/main.js public/img/logo.png
  touch models/intent_model.pkl
  touch tests/test_intents.py
  touch docs/architecture.md
  mkdir -p data/intents data/faq data/training data/responses data/embeddings data/logs data/schema data/config
  touch data/intents/general_intents.json data/intents/cannabis_intents.json data/intents/ar_vr_intents.json
  touch data/faq/faq_ganjaguru.txt data/faq/ai_ar_vr.txt
  touch data/training/my_training_data.json data/training/vectorized_data.pkl data/training/label_encoder.pkl
  touch data/responses/chatbot_responses.yml data/responses/system_messages.yml
  touch data/embeddings/word_vectors.vec data/embeddings/tfidf_matrix.pkl
  touch data/logs/chat_logs.txt data/logs/errors.log
  touch data/schema/data_schema.yml
  touch data/config/data_config.yml
}

# --- 4. Grant Full Privileges to the User ---
# Get the original user who invoked sudo
ORIGINAL_USER=${SUDO_USER:-$(whoami)}
echo "👑 Granting ownership of $PROJECT_ROOT to user '$ORIGINAL_USER'..."
chown -R $ORIGINAL_USER:$ORIGINAL_USER $PROJECT_ROOT

echo -e "\n✅ Success! The project is set up in /ganjaguru."
echo "🖥️  You may need to reboot or log out/in for the new environment variables to take effect."
