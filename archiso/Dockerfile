FROM archlinux:latest

# Обновление системы и установка archiso
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm archiso git

# Рабочая директория
WORKDIR /build

# Копируем проект VV OS
COPY .. /build/vv-os

# Копируем archiso профиль
COPY . /build/archiso-profile

# Создаем структуру для сборки
RUN mkdir -p /build/work /build/out

# Копируем vv-os в airootfs
RUN cp -r /build/vv-os /build/archiso-profile/airootfs/root/vv-os && \
    rm -rf /build/archiso-profile/airootfs/root/vv-os/archiso && \
    rm -rf /build/archiso-profile/airootfs/root/vv-os/.git

# Собираем ISO
RUN cd /build/archiso-profile && \
    mkarchiso -v -w /build/work -o /build/out .

# Выводим результат
CMD ["sh", "-c", "ls -lh /build/out/*.iso && echo 'ISO готов!' && tail -f /dev/null"]
