# frozen_string_literal: true

# Количество потоков, которые Puma будет использовать
max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS', max_threads_count)
threads min_threads_count, max_threads_count

# Устанавливаем таймауты для работы воркеров (для девелопмент окружения)
worker_timeout 3600 if ENV.fetch('RAILS_ENV', 'development') == 'development'

# Устанавливаем порт для Puma
port ENV.fetch('PORT', 3000)

# Устанавливаем окружение
environment ENV.fetch('RAILS_ENV', 'development')

# Устанавливаем pidfile
pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

# Позволяет Puma перезапускать приложение через команду `rails restart`
plugin :tmp_restart

# Указание пути до конфигурации приложения
rackup "config.ru"

# Параметры для логов и сокетов в продакшн
if ENV.fetch('RAILS_ENV', 'development') == 'production'
  pidfile "/home/deployer/qna-app-server/shared/tmp/pids/puma.pid"
  state_path "/home/deployer/qna-app-server/shared/tmp/pids/puma.state"
  stdout_redirect "/home/deployer/qna-app-server/shared/log/puma.stdout.log", "/home/deployer/qna-app-server/shared/log/puma.stderr.log", true
  bind "unix:///home/deployer/qna-app-server/shared/tmp/sockets/puma.sock"
end

# Настройки для количества потоков и воркеров
threads 1, 6
workers 2

# Прокачка Bundler
prune_bundler
