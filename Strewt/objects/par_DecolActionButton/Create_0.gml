event_inherited();

if (is_callable(command))
    command = new CimpliCommand(command, /* condition */ undefined);
