import 'package:intl/intl.dart';

class DateUtils {
  // Formato predeterminado: día/mes/año (ej. 17/05/2025)
  static String formatIsoDate(String isoDate, {String format = 'dd/MM/yyyy'}) {
    try {
      final dateTime = DateTime.parse(isoDate);
      final formatter = DateFormat(format);
      return formatter.format(dateTime);
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  // Formato sin hora: día de la semana, día, mes y año (ej. Sábado, 17 de mayo de 2025)
  static String formatIsoDateWithoutTime(String isoDate) {
    return formatIsoDate(isoDate, format: 'EEEE, d \'de\' MMMM \'de\' y');
  }

  // Formato corto: día/mes/año (ej. 17/05/25)
  static String formatIsoDateShort(String isoDate) {
    return formatIsoDate(isoDate, format: 'dd/MM/yy');
  }

  // Formato con hora: día/mes/año hora:minuto (ej. 17/05/2025 15:04)
  static String formatIsoDateWithTime(String isoDate) {
    return formatIsoDate(isoDate, format: 'dd/MM/yyyy HH:mm');
  }

  // Formato personalizado: permite pasar cualquier formato de DateFormat
  static String formatIsoDateCustom(String isoDate, String customFormat) {
    return formatIsoDate(isoDate, format: customFormat);
  }
}
