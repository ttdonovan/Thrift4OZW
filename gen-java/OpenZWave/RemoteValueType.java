/**
 * Autogenerated by Thrift Compiler (0.7.0)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 */
package OpenZWave;


import java.util.Map;
import java.util.HashMap;
import org.apache.thrift.TEnum;

public enum RemoteValueType implements org.apache.thrift.TEnum {
  ValueType_Bool(0),
  ValueType_Byte(1),
  ValueType_Decimal(2),
  ValueType_Int(3),
  ValueType_List(4),
  ValueType_Schedule(5),
  ValueType_Short(6),
  ValueType_String(7),
  ValueType_Button(8),
  ValueType_Max(8);

  private final int value;

  private RemoteValueType(int value) {
    this.value = value;
  }

  /**
   * Get the integer value of this enum value, as defined in the Thrift IDL.
   */
  public int getValue() {
    return value;
  }

  /**
   * Find a the enum type by its integer value, as defined in the Thrift IDL.
   * @return null if the value is not found.
   */
  public static RemoteValueType findByValue(int value) { 
    switch (value) {
      case 0:
        return ValueType_Bool;
      case 1:
        return ValueType_Byte;
      case 2:
        return ValueType_Decimal;
      case 3:
        return ValueType_Int;
      case 4:
        return ValueType_List;
      case 5:
        return ValueType_Schedule;
      case 6:
        return ValueType_Short;
      case 7:
        return ValueType_String;
      case 8:
        return ValueType_Button;
      case 8:
        return ValueType_Max;
      default:
        return null;
    }
  }
}