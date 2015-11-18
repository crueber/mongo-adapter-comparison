
# Comparsion of adapters.

During a comparison debacle, I decided to just pull together a little repo that compared a basic CRUD run at MongoDB via the three primary methods that make sense in node. Those methods are MongoDB (direct), Mongoose, and Waterline. Each of those is progressively more abstract, and I felt it was worth fully understanding how utilizing each, independently, would be useful. Also, it would make it easier to do some generalized profiling of how much faster/slower each library is.

# Dependencies

Just for reference, as dependencies can be a useful reference.

## Mongoose

```
mongoose@4.2.6 node_modules/mongoose
├── ms@0.7.1
├── async@0.9.0
├── hooks-fixed@1.1.0
├── regexp-clone@0.0.1
├── mpromise@0.5.4
├── mpath@0.1.1
├── muri@1.0.0
├── sliced@0.0.5
├── kareem@1.0.1
├── bson@0.4.19
├── mquery@1.6.3 (debug@2.2.0, bluebird@2.9.26)
└── mongodb@2.0.48 (es6-promise@2.1.1, readable-stream@1.0.31, kerberos@0.0.17, mongodb-core@1.2.21)
```

## MongoDB

```
mongodb@2.0.48 node_modules/mongodb
├── readable-stream@1.0.31 (string_decoder@0.10.31, isarray@0.0.1, core-util-is@1.0.1, inherits@2.0.1)
├── es6-promise@2.1.1
├── kerberos@0.0.17 (nan@2.0.9)
└── mongodb-core@1.2.21 (bson@0.4.19)
```

## Waterline

```
waterline@0.10.27 node_modules/waterline
├── deep-diff@0.3.3
├── async@1.2.1
├── switchback@1.1.3 (lodash@2.4.2)
├── waterline-criteria@0.11.2 (lodash@2.4.2)
├── bluebird@2.9.34
├── lodash@3.9.3
├── waterline-schema@0.1.18 (lodash@3.10.1)
├── anchor@0.10.5
└── prompt@0.2.14 (revalidator@0.1.8, pkginfo@0.3.1, read@1.0.7, winston@0.8.3, utile@0.2.1)

sails-mongo@0.11.4 node_modules/sails-mongo
├── async@1.4.2
├── waterline-errors@0.10.1
├── waterline-cursor@0.0.6 (async@0.9.2, lodash@2.4.2)
└── lodash@3.10.1
```