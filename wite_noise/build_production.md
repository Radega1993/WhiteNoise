# Guía para Build de Producción - Google Play

## Preparación del Build

### 1. Limpiar el proyecto
```bash
flutter clean
flutter pub get
```

### 2. Verificar configuración
- ✅ Versión actualizada en `pubspec.yaml`: 1.0.0+2
- ✅ Icono con fondo blanco configurado
- ✅ ProGuard rules configuradas
- ✅ Permisos de notificaciones agregados
- ✅ Botón de ajustes superior removido

### 3. Build de Release
```bash
# Build APK para testing
flutter build apk --release

# Build App Bundle para Google Play (recomendado)
flutter build appbundle --release
```

### 4. Ubicación de los archivos
- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **App Bundle**: `build/app/outputs/bundle/release/app-release.aab`

## Configuración para Google Play

### Información de la App
- **Nombre**: Workphony
- **Paquete**: com.example.wite_noise
- **Versión**: 1.0.0 (2)
- **Tamaño mínimo**: Android 5.0 (API 21)

### Características
- ✅ Sonidos blancos de alta calidad
- ✅ Timer Pomodoro funcional
- ✅ Interfaz moderna y responsive
- ✅ Notificaciones de timer
- ✅ Favoritos y historial
- ✅ Configuración de timer personalizable

### Permisos requeridos
- `INTERNET`: Para futuras actualizaciones
- `WAKE_LOCK`: Para mantener el timer activo
- `FOREGROUND_SERVICE`: Para notificaciones del timer
- `VIBRATE`: Para notificaciones
- `POST_NOTIFICATIONS`: Para notificaciones en Android 13+

## Checklist para Google Play

### Antes de subir
- [ ] Testear en diferentes dispositivos
- [ ] Verificar que el audio funcione correctamente
- [ ] Confirmar que el timer no tenga overflow
- [ ] Verificar que el icono tenga fondo blanco
- [ ] Probar todas las funcionalidades

### Información para la tienda
- **Descripción corta**: App de productividad con sonidos blancos y timer Pomodoro
- **Descripción completa**: Workphony es tu compañero perfecto para la productividad. Combina sonidos ambientales de alta calidad con un timer Pomodoro funcional para maximizar tu concentración y eficiencia.
- **Categoría**: Productividad
- **Etiquetas**: productividad, timer, pomodoro, sonidos blancos, concentración, focus

### Capturas de pantalla recomendadas
1. Pantalla principal con sonidos
2. Timer Pomodoro en funcionamiento
3. Configuración del timer
4. Lista de favoritos

## Comandos útiles

```bash
# Verificar el build
flutter build appbundle --release --analyze-size

# Instalar en dispositivo para testing
flutter install --release

# Ver logs en release
flutter run --release
```

## Notas importantes
- El App Bundle (.aab) es preferido por Google Play
- Asegúrate de firmar el APK antes de subirlo
- La primera subida puede tomar hasta 24 horas en ser revisada 