# 📱 WhiteNoise - Instrucciones de Uso

## 🚀 Cómo Ejecutar la Aplicación

### Opción 1: Ejecutar en Desarrollo
```bash
cd wite_noise
flutter run
```

### Opción 2: Construir APK para Android
```bash
cd wite_noise
flutter build apk --release
```
El APK se generará en: `build/app/outputs/flutter-apk/app-release.apk`

### Opción 3: Construir App Bundle para Google Play
```bash
cd wite_noise
flutter build appbundle --release
```
El AAB se generará en: `build/app/outputs/bundle/release/app-release.aab`

## 🎯 Funcionalidades Principales

### 🔊 Reproducción de Sonidos
1. **Navega a la pestaña "Sounds"**
2. **Toca una tarjeta de sonido** para reproducir/pausar
3. **Mantén presionado** para mostrar el control de volumen
4. **Toca el corazón** para agregar a favoritos
5. **Usa el botón "Stop All"** en la barra superior para detener todo

### ⏱️ Temporizador Pomodoro
1. **Ve a la pestaña "Timer"**
2. **Configura los tiempos** tocando "Timer Settings"
3. **Inicia el temporizador** con el botón verde
4. **Pausa/reanuda** según necesites
5. **Salta fases** con el botón azul
6. **Detén completamente** con el botón rojo

### 💖 Gestión de Favoritos
1. **Agrega sonidos** tocando el ícono de corazón
2. **Accede a favoritos** en la pestaña correspondiente
3. **Reproduce múltiples** favoritos simultáneamente
4. **Elimina favoritos** tocando el corazón nuevamente

## ⚙️ Configuración del Temporizador

### Configuraciones Disponibles:
- **Duración de trabajo**: Tiempo de cada sesión de trabajo (por defecto: 25 min)
- **Duración de descanso corto**: Tiempo de descanso entre sesiones (por defecto: 5 min)
- **Duración de descanso largo**: Tiempo de descanso después de 4 sesiones (por defecto: 15 min)
- **Sesiones antes del descanso largo**: Número de sesiones antes del descanso largo (por defecto: 4)
- **Auto-iniciar descansos**: Inicia automáticamente los descansos
- **Auto-iniciar trabajo**: Inicia automáticamente las sesiones de trabajo
- **Notificaciones**: Habilita/deshabilita las notificaciones

## 🔧 Solución de Problemas

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

## 📱 Permisos Requeridos

### Android
- **Internet**: Para futuras funcionalidades en línea
- **Wake Lock**: Para mantener el temporizador funcionando
- **Foreground Service**: Para reproducción en segundo plano
- **Post Notifications**: Para notificaciones del temporizador
- **Vibrate**: Para vibración en notificaciones

### iOS
- **Audio Background Mode**: Para reproducción en segundo plano
- **Notifications**: Para notificaciones del temporizador

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

## 📊 Características Técnicas

### Arquitectura
- **Patrón Provider**: Gestión de estado
- **Arquitectura limpia**: Separación de responsabilidades
- **Servicios singleton**: Audio, almacenamiento, notificaciones
- **Widgets reutilizables**: Componentes modulares

### Tecnologías
- **Flutter 3.x**: Framework de desarrollo
- **Dart 3.x**: Lenguaje de programación
- **AudioPlayers 5.x**: Reproducción de audio
- **SharedPreferences**: Almacenamiento local
- **Flutter Local Notifications**: Notificaciones push

### Optimizaciones
- **Reproducción en segundo plano**: El audio continúa cuando la app está minimizada
- **Gestión de memoria**: Liberación automática de recursos
- **Persistencia de datos**: Configuraciones guardadas localmente
- **Interfaz responsiva**: Se adapta a diferentes tamaños de pantalla

## 🚀 Próximas Características

- [ ] Más sonidos y categorías
- [ ] Modo de sueño con temporizador
- [ ] Estadísticas de uso
- [ ] Temas personalizables
- [ ] Sincronización en la nube
- [ ] Widgets para la pantalla de inicio
- [ ] Soporte para Apple Watch
- [ ] Integración con servicios de música

## 📞 Soporte

Si encuentras algún problema o tienes sugerencias:

1. Revisa la sección de [Solución de Problemas](#-solución-de-problemas)
2. Verifica que estés usando las versiones correctas de Flutter y Dart
3. Asegúrate de que todas las dependencias estén actualizadas
4. Revisa los logs de la aplicación para identificar errores específicos

---

**¡Disfruta mejorando tu productividad y concentración con WhiteNoise! 🎧✨** 