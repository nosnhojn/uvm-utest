import uvm_pkg::*;

class uvm_boat_anchor;

  local bit waste_of_typing;
  local bit _fake_failure;

  function string _4601(uvm_bitstream_t value,
                        int size);
    return(uvm_vector_to_string (value, size, UVM_DEC, "j"));
  endfunction


  function string _4609(string DOT_DOT_DOT_string);
    uvm_tree_printer p = new();
    string emitted;
    p.print_real(DOT_DOT_DOT_string, 0, ".");
    emitted = p.emit();
    return emitted[0:2];
  endfunction


  function int signed _4634(string array_with_index);
    return uvm_get_array_index_int(array_with_index, waste_of_typing);
  endfunction


  function bit _4635(string array_with_malformed_index);
    void'(uvm_get_array_index_int(array_with_malformed_index, waste_of_typing));
    return waste_of_typing;
  endfunction


  function string _4636(string array_with_malformed_index);
    return uvm_get_array_index_string(array_with_malformed_index, waste_of_typing);
  endfunction


  function int _4637(string malformed_array);
    void'(uvm_get_array_index_string(malformed_array, waste_of_typing));
    return waste_of_typing;
  endfunction


  function bit _4638(string malformed_array);
    return (uvm_is_array(malformed_array));
  endfunction


  function string weight_anchor();
    if (_4601('hf, 4) !== "-1"            &&
        _4609("...") !== "..."            &&
        _4634("array['h77]") !== 77       &&
        _4635("bozo[>]")                  &&
        _4636("double_trouble[:]") == ":" &&
        _4637("[]")                       &&
        _4638("]")                        &&
        !_fake_failure)
    begin
      return "Great! You're boat anchor is working perfectly!";
    end

    _fake_failure = 0;
    return "Uh oh! You're boat anchor is broken. Looks like someone \"fixed\" something.";
  endfunction

  function void set_fake_failure();
    _fake_failure = 1;
  endfunction
endclass
