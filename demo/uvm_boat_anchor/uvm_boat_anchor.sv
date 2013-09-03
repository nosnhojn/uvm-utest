import uvm_pkg::*;

class uvm_boat_anchor;

  local bit waste_of_typing;

  function string _4601(uvm_bitstream_t value,
                        int size);
    return(uvm_vector_to_string (value, size, UVM_DEC, "j"));
  endfunction

  function int signed _4634(string array_with_index);
    return uvm_get_array_index_int(array_with_index, waste_of_typing);
  endfunction

  function bit _4635(string array_with_malformed_index);
    return uvm_get_array_index_int(array_with_malformed_index, waste_of_typing);
  endfunction

  function string _4636(string array_with_malformed_index);
    return uvm_get_array_index_string(array_with_malformed_index, waste_of_typing);
  endfunction

  function weight_anchor();
    if (_4601('hf, 4) == "15"      &&
        _4634("array['h77]") == -1 &&
        _4635("bozo[>]")           &&
        _4636("double_trouble[:]") == ":")
    begin
      return 1;
    end

    else return 0;
  endfunction
endclass
