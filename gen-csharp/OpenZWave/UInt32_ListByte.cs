/**
 * Autogenerated by Thrift Compiler (0.7.0)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 */
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Thrift;
using Thrift.Collections;
using Thrift.Protocol;
using Thrift.Transport;
namespace OpenZWave
{

  [Serializable]
  public partial class UInt32_ListByte : TBase
  {
    private int _retval;
    private List<byte> __nodeNeighbors;

    public int Retval
    {
      get
      {
        return _retval;
      }
      set
      {
        __isset.retval = true;
        this._retval = value;
      }
    }

    public List<byte> _nodeNeighbors
    {
      get
      {
        return __nodeNeighbors;
      }
      set
      {
        __isset._nodeNeighbors = true;
        this.__nodeNeighbors = value;
      }
    }


    public Isset __isset;
    [Serializable]
    public struct Isset {
      public bool retval;
      public bool _nodeNeighbors;
    }

    public UInt32_ListByte() {
    }

    public void Read (TProtocol iprot)
    {
      TField field;
      iprot.ReadStructBegin();
      while (true)
      {
        field = iprot.ReadFieldBegin();
        if (field.Type == TType.Stop) { 
          break;
        }
        switch (field.ID)
        {
          case 1:
            if (field.Type == TType.I32) {
              Retval = iprot.ReadI32();
            } else { 
              TProtocolUtil.Skip(iprot, field.Type);
            }
            break;
          case 2:
            if (field.Type == TType.List) {
              {
                _nodeNeighbors = new List<byte>();
                TList _list4 = iprot.ReadListBegin();
                for( int _i5 = 0; _i5 < _list4.Count; ++_i5)
                {
                  byte _elem6 = 0;
                  _elem6 = iprot.ReadByte();
                  _nodeNeighbors.Add(_elem6);
                }
                iprot.ReadListEnd();
              }
            } else { 
              TProtocolUtil.Skip(iprot, field.Type);
            }
            break;
          default: 
            TProtocolUtil.Skip(iprot, field.Type);
            break;
        }
        iprot.ReadFieldEnd();
      }
      iprot.ReadStructEnd();
    }

    public void Write(TProtocol oprot) {
      TStruct struc = new TStruct("UInt32_ListByte");
      oprot.WriteStructBegin(struc);
      TField field = new TField();
      if (__isset.retval) {
        field.Name = "retval";
        field.Type = TType.I32;
        field.ID = 1;
        oprot.WriteFieldBegin(field);
        oprot.WriteI32(Retval);
        oprot.WriteFieldEnd();
      }
      if (_nodeNeighbors != null && __isset._nodeNeighbors) {
        field.Name = "_nodeNeighbors";
        field.Type = TType.List;
        field.ID = 2;
        oprot.WriteFieldBegin(field);
        {
          oprot.WriteListBegin(new TList(TType.Byte, _nodeNeighbors.Count));
          foreach (byte _iter7 in _nodeNeighbors)
          {
            oprot.WriteByte(_iter7);
          }
          oprot.WriteListEnd();
        }
        oprot.WriteFieldEnd();
      }
      oprot.WriteFieldStop();
      oprot.WriteStructEnd();
    }

    public override string ToString() {
      StringBuilder sb = new StringBuilder("UInt32_ListByte(");
      sb.Append("Retval: ");
      sb.Append(Retval);
      sb.Append(",_nodeNeighbors: ");
      sb.Append(_nodeNeighbors);
      sb.Append(")");
      return sb.ToString();
    }

  }

}