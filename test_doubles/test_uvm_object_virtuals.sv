`ifndef __TEST_UVM_OBJECT_VIRTUALS__
`define __TEST_UVM_OBJECT_VIRTUALS__

import uvm_pkg::*;
`include "uvm_macros.svh"

class test_uvm_object_virtuals extends uvm_object;
  bit set_name_called = 0;
  bit get_name_called = 0;
  bit get_full_name_called = 0;
  bit get_inst_id_called = 0;
  bit get_object_type_called = 0;
  bit get_type_name_called = 0;
  bit create_called = 0;
  bit clone_called = 0;
  bit do_print_called = 0;
  bit convert2string_called = 0;
  bit do_record_called = 0;
  bit do_copy_called = 0;
  bit do_compare_called = 0;
  bit do_pack_called = 0;
  bit do_unpack_called = 0;
  bit set_int_local_called = 0;
  bit set_string_local_called = 0;
  bit set_object_local_called = 0;
  bit __m_uvm_field_automation_called = 0;
  bit m_get_report_object_called = 0;

  function new(string name);
    super.new(name);
  endfunction

  // virtual methods

  function void set_name(string name);
    set_name_called = 1;
  endfunction

  function string get_name ();
    get_name_called = 1;
    return "";
  endfunction

  function string get_full_name ();
    get_full_name_called = 1;
    return "";
  endfunction

  function int get_inst_id ();
    get_inst_id_called = 1;
    return 0;
  endfunction

  function uvm_object_wrapper get_object_type ();
    get_object_type_called = 1;
    return null;
  endfunction

  function string get_type_name ();
    get_type_name_called = 1;
    return "";
  endfunction

  function uvm_object create (string name="");
    create_called = 1;
    return null;
  endfunction

  function uvm_object clone ();
    clone_called = 1;
    return null;
  endfunction

  function void do_print (uvm_printer printer);
    do_print_called = 1;
  endfunction

  function string convert2string();
    convert2string_called = 1;
    return "";
  endfunction

  function void do_record (uvm_recorder recorder);
    do_record_called = 1;
  endfunction

  function void do_copy (uvm_object rhs);
    do_copy_called = 1;
  endfunction

  function bit do_compare (uvm_object  rhs,
                           uvm_comparer comparer);
    do_compare_called = 1;
  endfunction

  function void do_pack (uvm_packer packer);
    do_pack_called = 1;
  endfunction

  function void do_unpack (uvm_packer packer);
    do_unpack_called = 1;
  endfunction

  function void  set_int_local    (string      field_name,
                                   uvm_bitstream_t value,
                                   bit         recurse=1);
    set_int_local_called = 1;
  endfunction

  function void  set_string_local (string field_name,
                                   string value,
                                   bit    recurse=1);
    set_string_local_called = 1;
  endfunction

  function void  set_object_local (string      field_name,
                                   uvm_object  value,
                                   bit         clone=1,
                                   bit         recurse=1);
    set_object_local_called = 1;
  endfunction

  function void __m_uvm_field_automation (uvm_object tmp_data__,
                                          int        what__,
                                          string     str__);
    __m_uvm_field_automation_called = 1;
  endfunction

  protected function uvm_report_object m_get_report_object();
    m_get_report_object_called = 1;
    return null;
  endfunction

endclass

`endif
