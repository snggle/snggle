// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEntryEntityCollection on Isar {
  IsarCollection<EntryEntity> get entries => this.collection();
}

const EntryEntitySchema = CollectionSchema(
  name: r'EntryEntity',
  id: 3917291818171161555,
  properties: {
    r'emailExistsBool': PropertySchema(
      id: 0,
      name: r'emailExistsBool',
      type: IsarType.bool,
    ),
    r'encryptedBool': PropertySchema(
      id: 1,
      name: r'encryptedBool',
      type: IsarType.bool,
    ),
    r'filesystemPathString': PropertySchema(
      id: 2,
      name: r'filesystemPathString',
      type: IsarType.string,
    ),
    r'index': PropertySchema(id: 3, name: r'index', type: IsarType.long),
    r'name': PropertySchema(id: 4, name: r'name', type: IsarType.string),
    r'passwordExistsBool': PropertySchema(
      id: 5,
      name: r'passwordExistsBool',
      type: IsarType.bool,
    ),
    r'pinnedBool': PropertySchema(
      id: 6,
      name: r'pinnedBool',
      type: IsarType.bool,
    ),
    r'usernameExistsBool': PropertySchema(
      id: 7,
      name: r'usernameExistsBool',
      type: IsarType.bool,
    ),
    r'website': PropertySchema(id: 8, name: r'website', type: IsarType.string),
  },

  estimateSize: _entryEntityEstimateSize,
  serialize: _entryEntitySerialize,
  deserialize: _entryEntityDeserialize,
  deserializeProp: _entryEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'index': IndexSchema(
      id: -5425839060849557016,
      name: r'index',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'index',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'filesystemPathString': IndexSchema(
      id: 4339951643106715750,
      name: r'filesystemPathString',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'filesystemPathString',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _entryEntityGetId,
  getLinks: _entryEntityGetLinks,
  attach: _entryEntityAttach,
  version: '3.3.2',
);

int _entryEntityEstimateSize(
  EntryEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.filesystemPathString.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.website.length * 3;
  return bytesCount;
}

void _entryEntitySerialize(
  EntryEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.emailExistsBool);
  writer.writeBool(offsets[1], object.encryptedBool);
  writer.writeString(offsets[2], object.filesystemPathString);
  writer.writeLong(offsets[3], object.index);
  writer.writeString(offsets[4], object.name);
  writer.writeBool(offsets[5], object.passwordExistsBool);
  writer.writeBool(offsets[6], object.pinnedBool);
  writer.writeBool(offsets[7], object.usernameExistsBool);
  writer.writeString(offsets[8], object.website);
}

EntryEntity _entryEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EntryEntity(
    emailExistsBool: reader.readBool(offsets[0]),
    encryptedBool: reader.readBool(offsets[1]),
    filesystemPathString: reader.readString(offsets[2]),
    id: id,
    index: reader.readLong(offsets[3]),
    name: reader.readString(offsets[4]),
    passwordExistsBool: reader.readBool(offsets[5]),
    pinnedBool: reader.readBool(offsets[6]),
    usernameExistsBool: reader.readBool(offsets[7]),
    website: reader.readString(offsets[8]),
  );
  return object;
}

P _entryEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _entryEntityGetId(EntryEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _entryEntityGetLinks(EntryEntity object) {
  return [];
}

void _entryEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  EntryEntity object,
) {}

extension EntryEntityQueryWhereSort
    on QueryBuilder<EntryEntity, EntryEntity, QWhere> {
  QueryBuilder<EntryEntity, EntryEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterWhere> anyIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'index'),
      );
    });
  }
}

extension EntryEntityQueryWhere
    on QueryBuilder<EntryEntity, EntryEntity, QWhereClause> {
  QueryBuilder<EntryEntity, EntryEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterWhereClause> indexEqualTo(
    int index,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'index', value: [index]),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterWhereClause> indexNotEqualTo(
    int index,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'index',
                lower: [],
                upper: [index],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'index',
                lower: [index],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'index',
                lower: [index],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'index',
                lower: [],
                upper: [index],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterWhereClause> indexGreaterThan(
    int index, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'index',
          lower: [index],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterWhereClause> indexLessThan(
    int index, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'index',
          lower: [],
          upper: [index],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterWhereClause> indexBetween(
    int lowerIndex,
    int upperIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'index',
          lower: [lowerIndex],
          includeLower: includeLower,
          upper: [upperIndex],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterWhereClause>
  filesystemPathStringEqualTo(String filesystemPathString) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'filesystemPathString',
          value: [filesystemPathString],
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterWhereClause>
  filesystemPathStringNotEqualTo(String filesystemPathString) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'filesystemPathString',
                lower: [],
                upper: [filesystemPathString],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'filesystemPathString',
                lower: [filesystemPathString],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'filesystemPathString',
                lower: [filesystemPathString],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'filesystemPathString',
                lower: [],
                upper: [filesystemPathString],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension EntryEntityQueryFilter
    on QueryBuilder<EntryEntity, EntryEntity, QFilterCondition> {
  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  emailExistsBoolEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'emailExistsBool', value: value),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  encryptedBoolEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedBool', value: value),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  filesystemPathStringEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'filesystemPathString',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  filesystemPathStringGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'filesystemPathString',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  filesystemPathStringLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'filesystemPathString',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  filesystemPathStringBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'filesystemPathString',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  filesystemPathStringStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'filesystemPathString',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  filesystemPathStringEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'filesystemPathString',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  filesystemPathStringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'filesystemPathString',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  filesystemPathStringMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'filesystemPathString',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  filesystemPathStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'filesystemPathString', value: ''),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  filesystemPathStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'filesystemPathString',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> indexEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'index', value: value),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  indexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'index',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> indexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'index',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> indexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'index',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  passwordExistsBoolEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'passwordExistsBool', value: value),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  pinnedBoolEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pinnedBool', value: value),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  usernameExistsBoolEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'usernameExistsBool', value: value),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> websiteEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  websiteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> websiteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> websiteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'website',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  websiteStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> websiteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> websiteContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition> websiteMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'website',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  websiteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'website', value: ''),
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterFilterCondition>
  websiteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'website', value: ''),
      );
    });
  }
}

extension EntryEntityQueryObject
    on QueryBuilder<EntryEntity, EntryEntity, QFilterCondition> {}

extension EntryEntityQueryLinks
    on QueryBuilder<EntryEntity, EntryEntity, QFilterCondition> {}

extension EntryEntityQuerySortBy
    on QueryBuilder<EntryEntity, EntryEntity, QSortBy> {
  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> sortByEmailExistsBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emailExistsBool', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  sortByEmailExistsBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emailExistsBool', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> sortByEncryptedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  sortByEncryptedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  sortByFilesystemPathString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  sortByFilesystemPathStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> sortByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> sortByIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  sortByPasswordExistsBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordExistsBool', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  sortByPasswordExistsBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordExistsBool', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> sortByPinnedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> sortByPinnedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  sortByUsernameExistsBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usernameExistsBool', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  sortByUsernameExistsBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usernameExistsBool', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> sortByWebsite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'website', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> sortByWebsiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'website', Sort.desc);
    });
  }
}

extension EntryEntityQuerySortThenBy
    on QueryBuilder<EntryEntity, EntryEntity, QSortThenBy> {
  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> thenByEmailExistsBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emailExistsBool', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  thenByEmailExistsBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emailExistsBool', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> thenByEncryptedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  thenByEncryptedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  thenByFilesystemPathString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  thenByFilesystemPathStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> thenByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> thenByIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  thenByPasswordExistsBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordExistsBool', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  thenByPasswordExistsBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordExistsBool', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> thenByPinnedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> thenByPinnedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  thenByUsernameExistsBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usernameExistsBool', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy>
  thenByUsernameExistsBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usernameExistsBool', Sort.desc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> thenByWebsite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'website', Sort.asc);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QAfterSortBy> thenByWebsiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'website', Sort.desc);
    });
  }
}

extension EntryEntityQueryWhereDistinct
    on QueryBuilder<EntryEntity, EntryEntity, QDistinct> {
  QueryBuilder<EntryEntity, EntryEntity, QDistinct>
  distinctByEmailExistsBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emailExistsBool');
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QDistinct> distinctByEncryptedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedBool');
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QDistinct>
  distinctByFilesystemPathString({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'filesystemPathString',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QDistinct> distinctByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'index');
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QDistinct>
  distinctByPasswordExistsBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'passwordExistsBool');
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QDistinct> distinctByPinnedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinnedBool');
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QDistinct>
  distinctByUsernameExistsBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'usernameExistsBool');
    });
  }

  QueryBuilder<EntryEntity, EntryEntity, QDistinct> distinctByWebsite({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'website', caseSensitive: caseSensitive);
    });
  }
}

extension EntryEntityQueryProperty
    on QueryBuilder<EntryEntity, EntryEntity, QQueryProperty> {
  QueryBuilder<EntryEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EntryEntity, bool, QQueryOperations> emailExistsBoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emailExistsBool');
    });
  }

  QueryBuilder<EntryEntity, bool, QQueryOperations> encryptedBoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedBool');
    });
  }

  QueryBuilder<EntryEntity, String, QQueryOperations>
  filesystemPathStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filesystemPathString');
    });
  }

  QueryBuilder<EntryEntity, int, QQueryOperations> indexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'index');
    });
  }

  QueryBuilder<EntryEntity, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<EntryEntity, bool, QQueryOperations>
  passwordExistsBoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passwordExistsBool');
    });
  }

  QueryBuilder<EntryEntity, bool, QQueryOperations> pinnedBoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinnedBool');
    });
  }

  QueryBuilder<EntryEntity, bool, QQueryOperations>
  usernameExistsBoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'usernameExistsBool');
    });
  }

  QueryBuilder<EntryEntity, String, QQueryOperations> websiteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'website');
    });
  }
}
