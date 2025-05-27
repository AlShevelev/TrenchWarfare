/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library logger;

import 'package:flutter/services.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:trench_warfare/database/dao/talker_history_dao.dart';
import 'package:trench_warfare/database/database.dart';
import 'package:trench_warfare/database/entities/talker_history_db_entity.dart';
import 'package:trench_warfare/shared/utils/extensions.dart';

part 'logger_entry_point.dart';
part 'history/talker_data_db_entity_mapper.dart';
part 'history/talker_db_history.dart';
