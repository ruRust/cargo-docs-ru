% Способы указания зависимостей

Ваши контейнеры (crates) могут зависеть от других библиотек с [crates.io], `git`
репозиториев, или поддиректорий в локальной файловой системе. Вы также можете
временно перезаписать расположение зависимости, например, чтобы проверить
исправление в пакете, с которым вы работаете локально. Вы можете указать
зависимости для различных платформ, и зависимости, используемые только при
разработке. Давайте посмотрим, как этим управлять.

# Указание зависимостей с crates.io

Cargo по-умолчанию настроен на поиск зависимостей по [crates.io]. В этом случае
требуется только название и строка, содержащая номер версии.
В [руководстве по Cargo](guide.html), мы указали зависимость от
контейнера `time`:

```toml
[dependencies]
time = "0.1.12"
```

Строка `"0.1.12"` является строкой указания семантической версии, также
известной как [SemVer]. Поскольку эта строка не содержит каких-либо операторов,
то эта строка интерпретируется также, как если бы мы указали строку `"^0.1.12"`,
которую называют мажорным ограничением.
Подробнее о семантическом версионировании можно прочитать на сайте
[semver.org](http://semver.org/lang/ru/).

[SemVer]: https://github.com/steveklabnik/semver#requirements

## Мажорные ограничения

**Мажорное ограничение** разрешает совместимые обновления указанной версии.
Обновление допускается, если в номере новой версии не изменяется самая левая
ненулевая цифра в группе *мажорная.минорная.патч*.
В этом случае, если мы запустим `cargo update -p time`, cargo обновит пакет
до `0.1.13`, если он доступен, но не обновит до `0.2.0`. Иначе, если указать
строку версии как `^1.0`, cargo обновит до `1.1`, но не `2.0`. `0.0.x`
считается несовместимым с любой другой версией.

Вот несколько примеров мажорных ограничений и версий, которые оно разрешает:

```notrust
^1.2.3 := >=1.2.3 <2.0.0
^1.2 := >=1.2.0 <2.0.0
^1 := >=1.0.0 <2.0.0
^0.2.3 := >=0.2.3 <0.3.0
^0.0.3 := >=0.0.3 <0.0.4
^0.0 := >=0.0.0 <0.1.0
^0 := >=0.0.0 <1.0.0
```

Хотя семантическое версионирование подразумевает, что нет совместимости до
1.0.0, многие программисты относятся к релизам `0.x.y` также, как к `1.x.y`
релизам: то есть `y` увеличивается для обратно совместимых баг-фиксов, а `x`
увеличивается при добавлении новых возможностей. Таким образом, Cargo считает
`0.x.y` и `0.x.z` версии совместимыми, если`z > y`.

## Минорные ограничения

**Минорное ограничение** указывает минимальную версию с некоторой возможностью
обновления.
Если вы указываете мажорную версию, минорную и номер патча или только мажорную
и минорную версию, то допускаются изменения только на уровне версии патча.
Если вы указываете только мажорный номер версии, то разрешается изменение на
уровне минорной версии и версии патча.

`~1.2.3` является примером минорного ограничения.

```notrust
~1.2.3 := >=1.2.3 <1.3.0
~1.2 := >=1.2.0 <1.3.0
~1 := >=1.0.0 <2.0.0
```

## Позиционные ограничения

**Позиционное ограничение** разрешает любую версию в соответствии с шаблоном.

`*`, `1.*` и `1.2.*` являются примерами позиционного ограничения.

```notrust
* := >=0.0.0
1.* := >=1.0.0 <2.0.0
1.2.* := >=1.2.0 <1.3.0
```

## Ограничения неравенством

**Ограничение неравенством** позволяет вручную указывать допустимый диапазон
версий или конкретную версию, которая требуется.

Ниже несколько примеров ограничения неравенством:

```notrust
>= 1.2.0
> 1
< 2
= 1.2.3
```

## Несколько ограничений

Несколько ограничений версии могут быть разделены через запятую,
например, `>= 1.2, < 1.5`.

# Указание зависимостей из `git` репозиториев

Для указания зависимости от библиотеки, расположенной в `git` репозитории,
вы должны, как минимум, указать расположение репозитория с помощью ключа `git`:

```toml
[dependencies]
rand = { git = "https://github.com/rust-lang-nursery/rand" }
```

Cargo загрузит `git` репозиторий, а затем
будет искать `Cargo.toml` для запрошенного контейнера
в любом месте `git` репозитория (не обязательно в корне).

Поскольку мы не указали никакой другой информации, Cargo предполагает,
что мы намерены использовать последний коммит в ветке `master`
для сборки нашего проекта.
Вы можете комбинировать ключ `git` с ключами `rev`, `tag` или `branch`,
чтобы указать что-то ещё. Вот пример указания того, что вы хотите
использовать последний коммит из ветки `next`:

```toml
[dependencies]
rand = { git = "https://github.com/rust-lang-nursery/rand", branch = "next" }
```

# Указание локальных зависимостей

Со временем наш проект `hello_world` из [руководства](guide.html) значительно
вырос! Понятно, что мы, вероятно, хотим разделить контейнер на несколько других.
Для этого Cargo поддерживает **пути до зависимостей**, которые обычно являются
под-контейнерами, которые живут в одном репозитории. Давайте начнем с создания
нового контейнера внутри нашего проекта `hello_world`:

```shell
# в папке hello_world/
$ cargo new hello_utils
```

Это создаст новую папку `hello_utils`, внутри которой `Cargo.toml` и папка `src`
будут готовы для настройки. Чтобы сообщить Cargo об этом, откройте
`hello_world/Cargo.toml` и добавьте `hello_utils` в ваши зависимости:

```toml
[dependencies]
hello_utils = { path = "hello_utils" }
```

Это укажет Cargo, что наш проект зависит от контейнера с именем `hello_utils`,
который находится в папке `hello_utils` (относительно `Cargo.toml`,
в котором это указано).

Вот и всё! Следующий `cargo build` автоматически соберёт `hello_utils` и все
свои зависимости, и другие контейнеры могут использовать под-контейнеры тем же
образом. Однако, контейнеры, которые используют зависимости, указанные по
локальному пути, не допускаются на [crates.io].
Если мы хотим опубликовать наш контейнер `hello_world`, мы должны сперва
опубликовать `hello_utils` на [crates.io](https://crates.io)
(или указать адрес `git` репозитория) и указать версию в строке зависимости:

```toml
[dependencies]
hello_utils = { path = "hello_utils", version = "0.1.0" }
```

# Переопределение зависимостей

Иногда вам может понадобиться переопределить одну из Cargo зависимостей.
Допустим, вы работаете над проектом, используя контейнер
[`uuid`](https://crates.io/crates/uuid), который зависит от
[`rand`](https://crates.io/crates/rand). Вы обнаружили ошибку в `rand`, и она
уже исправлена, по пока не опубликована. Вы хотите проверить это исправление,
поэтому давайте сначала посмотрим, как будет выглядеть ваш `Cargo.toml`:

```toml
[package]
name = "my-awesome-crate"
version = "0.2.0"
authors = ["The Rust Project Developers"]

[dependencies]
uuid = "0.2"
```

Чтобы переопределить зависимость `rand` контейнера `uuid`, мы будем
использовать [секцию `[replace]`] [replace-section] в `Cargo.toml`,
добавив это в конце:

[replace-section]: manifest.html#the-replace-section

```toml
[replace]
"rand:0.3.14" = { git = 'https://github.com/rust-lang-nursery/rand' }
```

Это означает, что `rand` версии 0.3.14, которую мы сейчас используем, будет
заменена веткой master репозитория `rand` на GitHub. В следующий раз, когда вы
выполните `cargo build`, Cargo возьмёт на себя проверку этого репозитория и
сборку `uuid` с обновлённой версией.

Обратите внимание, что в секции `[replace]` переопределяемый контейнер должен
иметь не только такое же имя, но и ту же версию, что и оригинальный. Это
означает, что если в `master` ветке версия `rand` была обновлена до, скажем,
0.4.3, то вам необходимо выполнить несколько дополнительных шагов для
тестирования контейнера:

1. Создайте форк оригинального репозитория
2. Создайте ветку, начинающуюся с релиза версии 0.3.14 (вероятно, отмечена
тегом 0.3.14)
3. Найдите исправление и отправьте его в вашу ветку
4. В секции `[replace]` укажите ваш git репозиторий и ветку

Этот метод также может быть полезен при тестировании новых функций зависимости.
Используя этот метод вы можете использовать ветку, в которой вы будете
добавлять фичи, а затем, когда она будет готова, вы можете отправить
pull-request в основной репозиторий. Пока вы будете ожидать одобрения
pull-request, вы можете работать локально с использованием `[replace]`, а
затем, когда pull-request будет принят и опубликован, вы можете удалить секцию
`[remove]` и использовать недавно опубликованную версию.

Примечание: в файле `Cargo.lock` будут перечислены две версии переопределённого
контейнера: один для оригинального контейнера, а другой для версии, указанной в
`[replace]`. С помощью `cargo build -v` можно проверить, что только одна версия
используется при сборке.

### Переопределение локальными зависимостями

Иногда вы только временно работаете над контейнером, и вы не хотите изменять
`Cargo.toml` с помощью секции `[replace]`, описанной выше. Для этого случая
Cargo предлагает ограниченную версию переопределений, называемую **путевыми
переопределениями**.

Как и раньше, предположим, вы работаете над проектом, использующем
[`uuid`](https://crates.io/crates/uuid), который зависит от
[`rand`](https://crates.io/crates/rand). На этот раз вы тот, кто нашёл ошибку в
контейнере `rand` и вы хотите написать патч и проверить его, используя вашу
версию `rand` в контейнере `uuid`. Вот, как выглядит `Cargo.toml`
в контейнере `uuid`:

```toml
[package]
name = "uuid"
version = "0.2.2"
authors = ["The Rust Project Developers"]

[dependencies]
rand = { version = "0.3", optional = true }
```

Вы тестируете локальную копию `rand`, скажем, в каталоге `~/src`:

```shell
$ cd ~/src
$ git clone https://github.com/rust-lang-nursery/rand
```

Переопределение пути передаётся в Cargo через механизм конфигурации
`.cargo/config`. Если Cargo обнаружит эту конфигурацию при сборке вашего пакета,
он будет использовать переопределённый на вашей локальной машине путь вместо
источника, указанного в `Cargo.toml`.

Cargo ищет каталог с именем `.cargo` вверх по иерархии каталогов вашего проекта.
Если ваш проект находится в `/path/to/project/uuid`, он будет искать `.cargo` в:

* `/path/to/project/uuid`
* `/path/to/project`
* `/path/to`
* `/path`
* `/`

Это позволяет вам указать свои переопределения в родительском каталоге, который
включает в себя пакеты, которые вы обычно используете на локальном компьютере,
и использовать их во всех проектах.

Чтобы указать переопределения, создайте файл `.cargo/config` у некоторого предка
каталога вашего проекта (обычно его размещают в корневой директории вашего кода
или в вашем домашнем каталоге).

Поместите это внутрь файла:

```toml
paths = ["/path/to/project/rand"]
```

Этот массив должен заполняться каталогами, содержащими `Cargo.toml`.
В этом случае мы добавляем переопределение `rand`, поэтому
этот контейнер будет единственным, который будет переопределен.
Указанный путь должен быть абсолютным.

Однако переопределения пути более ограничены, чем секция `[replace]`, тем более,
что они не могут изменить структуру графика зависимостей.
В заменяемом контейнере набор зависимостей должен быть точно таким же, как и в
оригинальном. Например, это означает, что переопределения пути не могут
использоваться для проверки добавления зависимостей к контейнеру,
в этой ситуации следует использовать секцию `[replace]`.

Примечание: использование локальной конфигурации для переопределения
путей работает только для контейнеров, которые были опубликованы на [crates.io].
Вы не можете использовать эту функцию для локальных неопубликованных контейнеров.

Более подробную информацию о локальной конфигурации можно найти в
[документации по конфигурации](config.html).

# Платформо-специфичные зависимости


Специфичные для платформы зависимости указываются в том же формате, как и
обычные, но указаны под секцией `target`. Для определения этих секций
используется обычный Rust-like синтаксис `#[cfg]`:

```toml
[target.'cfg(windows)'.dependencies]
winhttp = "0.4.0"

[target.'cfg(unix)'.dependencies]
openssl = "1.0.1"

[target.'cfg(target_arch = "x86")'.dependencies]
native = { path = "native/i686" }

[target.'cfg(target_arch = "x86_64")'.dependencies]
native = { path = "native/x86_64" }
```

Как и в случае с Rust, здесь поддерживаются операторы `not`,`any` и `all` для
объединения различных пар имя/значение. Обратите внимание, что синтаксис `cfg`
доступен только с Cargo 0.9.0 (Rust 1.8.0).

В дополнение к синтаксису `#[cfg]` Cargo также поддерживает перечисление полной
цели, к которой будут относиться зависимости:

```toml
[target.x86_64-pc-windows-gnu.dependencies]
winhttp = "0.4.0"

[target.i686-unknown-linux-gnu.dependencies]
openssl = "1.0.1"
```

Если вы используете кастомную спецификацию целевой платформы, укажите полный
путь и имя файла:

```toml
[target."x86_64/windows.json".dependencies]
winhttp = "0.4.0"

[target."i686/linux.json".dependencies]
openssl = "1.0.1"
native = { path = "native/i686" }

[target."x86_64/linux.json".dependencies]
openssl = "1.0.1"
native = { path = "native/x86_64" }
```

# Зависимости для режима разработки

Вы можете добавить секцию `[dev-dependencies]` в свой `Cargo.toml`, формат
которого эквивалентен `[dependencies]`:

```toml
[dev-dependencies]
tempdir = "0.3"
```

Dev-зависимости используются не при компиляции сборки, а при компиляции тестов,
примеров и бенчмарков.

Эти зависимости *не* распространяются на другие пакеты, которые зависят от
этого пакета.

Вы также можете указать платформо-специфичные зависимости, используя
`dev-dependencies` вместо `dependencies` в секции `target`. Например:

```toml
[target.'cfg(unix)'.dev-dependencies]
mio = "0.0.1"
```

[crates.io]: https://crates.io/

# Зависимости для сборки

Вы можете объявить зависимость от других контейнеров на основе Cargo для их
использования в сценариях сборки. Зависимости объявляются через раздел
`build-dependencies` манифеста:

```toml
[build-dependencies]
gcc = "0.3"
```

Сценарий сборки **не** имеет доступа к зависимостям, указанным в секции
`dependencies` или `dev-dependencies`. Зависимости сборки также не будут
доступны для самого пакета, если они не указаны в разделе `dependencies`.
Сам пакет и сценарий его сборки собираются отдельно, поэтому их зависимости
могут не совпадать. Cargo.toml проще и чище, используя независимые зависимости
для независимых целей.

# Выбор возможностей (features)

Если пакет зависит от некоторых возможностей, вы можете выбрать,
какие из них использовать:

```toml
[dependencies.awesome]
version = "1.3.5"
default-features = false # не включать стандартные возможности, и, опционально,
                         # включить указанные возможности
features = ["secure-password", "civet"]
```

Больше информации о возможностях можно найти в
[документации по manifest](manifest.html#the-features-section).