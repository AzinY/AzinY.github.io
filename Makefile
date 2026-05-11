.PHONY: help preview preview-ru preview-en render render-ru render-en serve clean install

# If quarto is not on PATH, fall back to local install in ~/.local/bin
QUARTO ?= $(shell command -v quarto 2>/dev/null || echo $$HOME/.local/bin/quarto)

help:
	@echo "Команды:"
	@echo "  make preview-ru    — локальный preview русского сайта (порт 4848)"
	@echo "  make preview-en    — локальный preview английского сайта (порт 4849)"
	@echo "  make preview       — оба сразу в фоне"
	@echo "  make render        — собрать обе версии в _site/"
	@echo "  make render-ru     — собрать только русскую"
	@echo "  make render-en     — собрать только английскую"
	@echo "  make serve         — поднять _site/ на :8000 (для проверки RU↔EN)"
	@echo "  make clean         — удалить _site, _freeze, .quarto"
	@echo "  make install       — установить Python-зависимости"

preview-ru:
	cd ru && $(QUARTO) preview --port 4848 --no-browser --host 127.0.0.1

preview-en:
	cd en && $(QUARTO) preview --port 4849 --no-browser --host 127.0.0.1

preview:
	@echo "RU: http://127.0.0.1:4848 / EN: http://127.0.0.1:4849"
	@trap 'kill 0' INT TERM EXIT; \
	  (cd ru && $(QUARTO) preview --port 4848 --no-browser --host 127.0.0.1) & \
	  (cd en && $(QUARTO) preview --port 4849 --no-browser --host 127.0.0.1) & \
	  wait

render: render-ru render-en
	@echo "Готово: _site/ (RU) и _site/en/ (EN)"

render-ru:
	cd ru && $(QUARTO) render

render-en:
	cd en && $(QUARTO) render

serve:
	@echo "Открой http://127.0.0.1:8000/  (Ctrl+C — остановить)"
	@cd _site && python3 -m http.server 8000

clean:
	rm -rf _site ru/.quarto en/.quarto ru/_freeze en/_freeze

install:
	pip3 install -r requirements.txt
