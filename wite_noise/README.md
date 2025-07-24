# WhiteNoise - Focus & Productivity App

Una aplicación de sonidos blancos y ambientes diseñada para mejorar la concentración y productividad. Inspirada en herramientas como Noisli, Brain.fm y Endel.

## 🎯 Características

### 🔊 Reproducción de Audio
- **Reproducción individual**: Cada sonido se puede reproducir/pausar independientemente
- **Mezcla de sonidos**: Reproduce múltiples sonidos simultáneamente
- **Control de volumen individual**: Ajusta el volumen de cada sonido por separado
- **Reproducción en bucle**: Los sonidos se reproducen continuamente
- **Reproducción en segundo plano**: El audio continúa cuando la app está en segundo plano

### ⏱️ Temporizador Pomodoro
- **Temporizador configurable**: Ajusta duración de trabajo, descansos cortos y largos
- **Sesiones automáticas**: Configuración para auto-iniciar descansos y sesiones de trabajo
- **Notificaciones**: Alertas cuando terminan las sesiones
- **Controles completos**: Iniciar, pausar, reanudar, saltar y detener
- **Indicador visual**: Barra de progreso y colores por fase

### 💾 Persistencia de Datos
- **Favoritos**: Guarda tus sonidos preferidos
- **Configuraciones**: Recuerda volúmenes y configuraciones del temporizador
- **Historial**: Últimos sonidos utilizados
- **Sincronización**: Los datos se mantienen entre sesiones

### 🎨 Interfaz Moderna
- **Diseño Material 3**: Interfaz moderna y elegante
- **Navegación por pestañas**: Acceso rápido a sonidos, favoritos y temporizador
- **Animaciones suaves**: Transiciones y efectos visuales
- **Responsive**: Se adapta a diferentes tamaños de pantalla
- **Modo oscuro**: Soporte para tema oscuro del sistema

## 🚀 Instalación

### Prerrequisitos
- Flutter SDK 3.0.0 o superior
- Dart SDK 3.0.0 o superior
- Android Studio / VS Code
- Dispositivo Android/iOS o emulador

### Pasos de Instalación

1. **Clona el repositorio**
   ```bash
   git clone <repository-url>
   cd wite_noise
   ```

2. **Instala las dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecuta la aplicación**
   ```bash
   flutter run
   ```

### Construcción para Producción

**Android (APK)**
```bash
flutter build apk --release
```

**Android (App Bundle)**
```bash
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

## 📱 Uso de la Aplicación

### Reproducción de Sonidos
1. **Navega a la pestaña "Sounds"**
2. **Toca una tarjeta de sonido** para reproducir/pausar
3. **Mantén presionado** para mostrar el control de volumen
4. **Toca el corazón** para agregar a favoritos
5. **Usa el botón "Stop All"** en la barra superior para detener todo

### Temporizador Pomodoro
1. **Ve a la pestaña "Timer"**
2. **Configura los tiempos** tocando "Timer Settings"
3. **Inicia el temporizador** con el botón verde
4. **Pausa/reanuda** según necesites
5. **Salta fases** con el botón azul
6. **Detén completamente** con el botón rojo

### Gestión de Favoritos
1. **Agrega sonidos** tocando el ícono de corazón
2. **Accede a favoritos** en la pestaña correspondiente
3. **Reproduce múltiples** favoritos simultáneamente
4. **Elimina favoritos** tocando el corazón nuevamente

## 🏗️ Arquitectura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/                   # Modelos de datos
│   ├── sound.dart           # Modelo de sonido
│   ├── player_state.dart    # Estado del reproductor
│   └── timer_settings.dart  # Configuraciones del temporizador
├── services/                # Servicios de negocio
│   ├── audio_service.dart   # Manejo de audio
│   ├── storage_service.dart # Almacenamiento local
│   └── timer_service.dart   # Temporizador Pomodoro
├── providers/               # Gestión de estado
│   └── app_provider.dart    # Provider principal
├── screens/                 # Pantallas de la aplicación
│   └── home_screen.dart     # Pantalla principal
└── widgets/                 # Widgets reutilizables
    ├── sound_card.dart      # Tarjeta de sonido
    └── pomodoro_timer.dart  # Widget del temporizador
```

## 🔧 Configuración

### Permisos Requeridos

**Android** (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

**iOS** (`ios/Runner/Info.plist`)
```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

### Configuración de Notificaciones

La aplicación utiliza `flutter_local_notifications` para las notificaciones del temporizador. Las notificaciones se configuran automáticamente al iniciar la app.

## 🎵 Agregar Nuevos Sonidos

1. **Coloca el archivo de audio** en `assets/music/`
2. **Coloca la imagen** en `assets/images/`
3. **Actualiza `pubspec.yaml`** para incluir los nuevos assets
4. **Modifica `_loadSounds()`** en `app_provider.dart`

Ejemplo:
```dart
Sound(
  id: 'ocean',
  name: 'Ocean Waves',
  imagePath: 'assets/images/ocean.jpg',
  audioPath: 'music/ocean.mp3',
  category: 'Nature',
  defaultVolume: 0.5,
),
```

## 🐛 Solución de Problemas

### Error de Dependencias
```bash
flutter clean
flutter pub get
```

### Error de Audio
- Verifica que los archivos de audio estén en el formato correcto (MP3)
- Asegúrate de que los archivos no estén corruptos
- Revisa los permisos de audio en el dispositivo

### Error de Notificaciones
- Verifica que las notificaciones estén habilitadas en la configuración del dispositivo
- En Android 13+, asegúrate de que el permiso POST_NOTIFICATIONS esté concedido

### Error de Compilación
```bash
flutter doctor
flutter clean
flutter pub get
flutter run
```

## 📈 Próximas Características

- [ ] Más sonidos y categorías
- [ ] Modo de sueño con temporizador
- [ ] Estadísticas de uso
- [ ] Temas personalizables
- [ ] Sincronización en la nube
- [ ] Widgets para la pantalla de inicio
- [ ] Soporte para Apple Watch
- [ ] Integración con servicios de música

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📞 Soporte

Si encuentras algún problema o tienes sugerencias, por favor:

1. Revisa la sección de [Solución de Problemas](#-solución-de-problemas)
2. Busca en los [Issues](https://github.com/username/wite_noise/issues)
3. Crea un nuevo issue con detalles del problema

---

**Desarrollado con ❤️ para mejorar tu productividad y concentración**
