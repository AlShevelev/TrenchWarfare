library carriers_phase_library;

import 'package:collection/collection.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/aggressive/shared/aggressive_ai_shared_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/influence_map/influence_map_library.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';
import 'package:tuple/tuple.dart';

part 'active_carrier_troop_transfers.dart';
part 'carriers_phase.dart';
part 'transfers/troop_transfer.dart';
part 'transfers/dto/carrier_on_cell.dart';
part 'transfers/troop_transfer_state.dart';
part 'transfers/transitions/gathering_transition.dart';
part 'transfers/transitions/init_transition.dart';
part 'transfers/transitions/landing_transition.dart';
part 'transfers/transitions/movement_after_lading_transition.dart';
part 'transfers/transitions/transporting_transition.dart';
part 'transfers/transitions/transition.dart';
