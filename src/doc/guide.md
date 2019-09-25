% Руководство по Cargo

Добро пожаловать в руководство по Cargo. Это руководство даст вам все необходимое, чтобы вы могли использовать Cargo для разработки проектов на языке программирования Rust.

# Зачем нужен Cargo? 

Cargo - это инструмент, который позволяет указывать необходимые зависимости для проектов на языке Rust и убедиться, что вы получите воспроизводимые сборки.

Для достижения этих целей, Cargo выполняет следующие действия:

* Создает два файла с некоторой необходимой информацией о проекте.
* Получает и собирает зависимости вашего проекта.
* Запускает `rustc` или другие инструменты сборки со всеми необходимыми параметрами для правильной сборки вашего проекта.
* Предоставляет все необходимые условия, чтобы работа с проектами на Rust стала проще.

# Создание нового проекта

Для создания нового проекта с помощью Cargo, воспользуйтесь командой `cargo new`:

```shell
$ cargo new hello_world --bin
```

Мы передали аргумент `--bin`, потому что мы создаем исполняемую программу: если мы
решим создать библиотеку, то этот аргумент необходимо убрать. Эта команда по умолчанию так же создает `git` репозиторий. Если вы этого не планировали, добавьте аргумент `--vcs none`.

Давайте посмотрим, что Cargo сгенерировал для нас:

```shell
$ cd hello_world
$ tree .
.
├── Cargo.toml
└── src
    └── main.rs

1 directory, 2 files
```

Если бы мы выполнили команду `cargo new hello_world` без аргумента `--bin`, тогда
мы бы получили файл `lib.rs`, вместо `main.rs`. В данный момент это все, что нам необходимо для начала. Первым делом, давайте посмотрим, что за файл `Cargo.toml`:

```toml
[package]
name = "hello_world"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]
```

Этот файл называется **манифестом** и содержит в себе все метаданные, которые необходимы Cargo,
чтобы скомпилировать ваш проект.

Вот, что мы найдем в файле `src/main.rs`:

```
fn main() {
    println!("Hello, world!");
}
```

Cargo сгенерировал “hello world” для нас. Давайте скомпилируем его:

<pre><code class="language-shell"><span class="gp">$</span> cargo build
<span style="font-weight: bold"
class="s1">   Compiling</span> hello_world v0.1.0 (file:///path/to/project/hello_world)</code></pre>

А затем запустите его:

```shell
$ ./target/debug/hello_world
Hello, world!
```

Вы так же можете использовать `cargo run`, чтобы скомпилировать и запустить проект. Все за одну команду. (Вы не увидите фразу `Compiling`, если вы не вносили каких-либо изменений в исходный код, с момента последней компиляции):

<pre><code class="language-shell"><span class="gp">$</span> cargo run
<span style="font-weight: bold"
class="s1">   Compiling</span> hello_world v0.1.0 (file:///path/to/project/hello_world)
<span style="font-weight: bold"
class="s1">   Running</span> `target/debug/hello_world`
Hello, world!</code></pre>

Теперь вы увидите новый файл - `Cargo.lock`. Он содержит в себе информацию о зависимостях проекта. Т.к мы еще не добавили зависимости, для нас это, пока, не очень интересно.

После того, как вы закончите работу над программой и будете готовы выпустить релизную версию, вы можете воспользоваться командой `cargo build --release`, чтобы скомпилировать ваш проект с включенной оптимизацией:

<pre><code class="language-shell"><span class="gp">$</span> cargo build --release
<span style="font-weight: bold"
class="s1">   Compiling</span> hello_world v0.1.0 (file:///path/to/project/hello_world)</code></pre>

`cargo build --release` создаст исполняемый файл в директории
`target/release`, вместо `target/debug`.

Компиляция в режиме дебага является стандартной при разработке, т.к компилятору необходимо меньше времени на компиляцию проекта, из-за выключенной оптимизации кода, но исполняемый файл будет работать медленнее. Релизная версия требует больше времени для сборки проекта, но финальный результат будет работать быстрее.

# Работа с существующим Cargo проектом

Если вы скачиваете существующий проект, который использует Cargo, то начать работу с ним будет очень просто.

Для начала, давайте загрузим какой-либо проект. В данном примере мы воспользуемся `rand`. Заберем копию его репозиторий с GitHub:

```sh
$ git clone https://github.com/rust-lang-nursery/rand.git
$ cd rand
```

Чтобы собрать `rand` воспользуемся командой `cargo build`:

<pre><code class="language-shell"><span class="gp">$</span> cargo build
<span style="font-weight: bold" class="s1">   Compiling</span> rand v0.1.0 (file:///path/to/project/rand)</code></pre>

Cargo получит все зависимости для данного проекта, а затем соберет их вместе с проектом.

# Добавление зависимостей из crates.io

[crates.io] - это центральный репозиторий сообщества Rust, который служит в качестве хранилища, в котором можно найти и загрузить необходимые пакеты. `cargo` настроен так, что использует данный репозиторий по умолчанию.

Чтобы добавить зависимую библиотеку, которая расположена на [crates.io], просто добавьте ее в ваш `Cargo.toml`.

[crates.io]: https://crates.io/

## Добавление зависимостей

Если в вашем `Cargo.toml` еще нет раздела `[dependencies]`, добавьте его,
затем перечислите контейнеры и их версии, которые вы хотите использовать. В этом примере мы добавим в зависимости контейнер `time`:

```toml
[dependencies]
time = "0.1.12"
```

Строка версии должна соответствовать [семантическому версионированию]. В документе [определение зависимостей](specifying-dependencies.html), вы найдете больше информации о всех возможностях, которые вам предоставлены.

[семантическому версионированию]: https://github.com/steveklabnik/semver#requirements

Если нам так же необходимо добавить новый контейнер, как зависимость, например, `regex`, нам не нужно добавлять блок `[dependencies]` каждый раз. Посмотрите, как выглядит наш
`Cargo.toml` файл, в котором перечислены две зависимости - `time` и `regex`
crates:

```toml
[package]
name = "hello_world"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]

[dependencies]
time = "0.1.12"
regex = "0.1.41"
```

Запустите заново `cargo build`, и Cargo загрузит все новые зависимости, а так же их зависимости. Скомпилирует эти зависимости и обновит `Cargo.lock`:

<pre><code class="language-shell"><span class="gp">$</span> cargo build
<span style="font-weight: bold" class="s1">    Updating</span> registry `https://github.com/rust-lang/crates.io-index`
<span style="font-weight: bold" class="s1"> Downloading</span> memchr v0.1.5
<span style="font-weight: bold" class="s1"> Downloading</span> libc v0.1.10
<span style="font-weight: bold" class="s1"> Downloading</span> regex-syntax v0.2.1
<span style="font-weight: bold" class="s1"> Downloading</span> memchr v0.1.5
<span style="font-weight: bold" class="s1"> Downloading</span> aho-corasick v0.3.0
<span style="font-weight: bold" class="s1"> Downloading</span> regex v0.1.41
<span style="font-weight: bold" class="s1">   Compiling</span> memchr v0.1.5
<span style="font-weight: bold" class="s1">   Compiling</span> libc v0.1.10
<span style="font-weight: bold" class="s1">   Compiling</span> regex-syntax v0.2.1
<span style="font-weight: bold" class="s1">   Compiling</span> memchr v0.1.5
<span style="font-weight: bold" class="s1">   Compiling</span> aho-corasick v0.3.0
<span style="font-weight: bold" class="s1">   Compiling</span> regex v0.1.41
<span style="font-weight: bold" class="s1">   Compiling</span> hello_world v0.1.0 (file:///path/to/project/hello_world)</code></pre>

Наш `Cargo.lock` хранит в себе информацию о том, какую именно версию (с ревизией) мы используем.

Теперь, если `regex` получит обновление, мы будем собирать проект с той же версией, которая указана в `Cargo.lock`, пока не воспользуемся командой `cargo update`.

Теперь вы можете использовать библиотеку `regex`, используя `extern crate` в `main.rs`.

```
extern crate regex;

use regex::Regex;

fn main() {
    let re = Regex::new(r"^\d{4}-\d{2}-\d{2}$").unwrap();
    println!("Did our date match? {}", re.is_match("2014-01-01"));
}
```

Запустим этот код и увидим:

<pre><code class="language-shell"><span class="gp">$</span> cargo run
<span style="font-weight: bold" class="s1">     Running</span> `target/hello_world`
Did our date match? true</code></pre>

# Схема проекта

Cargo размещает файлы определенным образом, чтобы можно было начать работать с новым Cargo проектом:

```shell
.
├── Cargo.lock
├── Cargo.toml
├── benches
│   └── large-input.rs
├── examples
│   └── simple.rs
├── src
│   ├── bin
│   │   └── another_executable.rs
│   ├── lib.rs
│   └── main.rs
└── tests
    └── some-integration-tests.rs
```

* `Cargo.toml` и `Cargo.lock` размещается в корневой директории вашего проекта.
* Исходный код отправляется в директорию `src`.
* Стандартный файл библиотеки расположен по адресу `src/lib.rs`.
* Стандартный исполняемый файл находится по адресу `src/main.rs`.
* Другие исполняемые файлы могут быть расположены в `src/bin/*.rs`.
* Интеграционные тесты находятся в директории `tests` (юнит тесты в том файле, который они тестируют).
* Исполняемые примеры распологаются в директории `examples`.
* Бенчмарки хранятся в директории `benches`.

Более детально это рассмотрено в [описание манифеста](manifest.html#the-project-layout).

# Cargo.toml vs Cargo.lock

`Cargo.toml` и `Cargo.lock` служат для двух разных целей. Перед тем, как мы начнем говорить об этом, рассмотрим небольшое изложение того, что мы изучили ранее:

* `Cargo.toml` - необходим для описания зависимостей, которые добавляете вы.
* `Cargo.lock` - хранит в себе точную информацию о зависимостях. Его создает Cargo и он не должен изменяться в ручную.

Если вы создаете библиотеку, которую будут использовать другие проекты в качестве зависимости, добавьте `Cargo.lock` в ваш `.gitignore` файл. Если вы создаете исполняемые файлы, например,
консольную программу, добавьте `Cargo.lock` в ваш `git` репозиторий. Если вам интересно, почему это так, прочитайте ["Почему приложения хранят в репозитории `Cargo.lock`, а библиотеки нет?" в
FAQ](faq.html#why-do-binaries-have-cargolock-in-version-control-but-not-libraries).

Давайте копнем немного глубже.

`Cargo.toml` - это файл **манифеста**, в котором вы можете указать кучу разных метаданных о проекте. Например, мы можем указать, что мы зависим от другого проекта:

```toml
[package]
name = "hello_world"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]

[dependencies]
rand = { git = "https://github.com/rust-lang-nursery/rand.git" }
```

Этот проект имеет одну зависимость - библиотеку `rand`. В данном примере мы указатели в качестве зависимости конкретный git репозиторий, расположенный на GitHub. Т.к мы не указали какой-либо другой информации, Cargo предполагает, что мы будем использовать последний коммит с ветки `master`, чтобы собрать наш проект.

Звучит круто? Ну, есть одна проблема: Если вы собрали ваш проект сегодня, а потом отправили копию мне, но, я соберу его только завтра, может случится что-то плохое. В репозитории `rand` могут появиться новые коммиты, и моя сборка будет содержать новые коммиты, а ваша - нет.
Таким образом, мы получим разные сборки. Это не очень хорошо, так как мы хотим получать воспроизводимые сборки.

Мы можем решить данную проблему, добавив `rev` в строку с зависимостью в файле `Cargo.toml`:

```toml
[dependencies]
rand = { git = "https://github.com/rust-lang-nursery/rand.git", rev = "9f35b8e" }
```

Теперь сборки будут одинаковые. Но есть небольшой недостаток: теперь нам нужно обновлять SHA-1 хеш коммита каждый раз, когда мы захотим обновить версию библиотеки. Это так утомительно и может привести к ошибкам!

Вспомним про `Cargo.lock`. Благодаря нему нам не обязательно каждый раз в ручную указывать точную версию библиотеки, которую мы будем использовать. Cargo сделает это за нас. Все, что нам нужно - это манифест. Например, вот такой:

```toml
[package]
name = "hello_world"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]

[dependencies]
rand = { git = "https://github.com/rust-lang-nursery/rand.git" }
```

Cargo заберет последний коммит и запишет эту информацию в ваш `Cargo.lock` во время первой сборки. Этот файл будет выглядеть вот так:

```toml
[root]
name = "hello_world"
version = "0.1.0"
dependencies = [
 "rand 0.1.0 (git+https://github.com/rust-lang-nursery/rand.git#9f35b8e439eeedd60b9414c58f389bdc6a3284f9)",
]

[[package]]
name = "rand"
version = "0.1.0"
source = "git+https://github.com/rust-lang-nursery/rand.git#9f35b8e439eeedd60b9414c58f389bdc6a3284f9"

```

Как вы можете видеть, в `Cargo.lock` довольно много информации. Включая точную версию библиотеки, которую мы будем использовать для сборки. Теперь, если мы передаем проект кому-то другому, то сборки проекта будут одинаковые и нам не нужно обновлять хеш коммита каждый раз. Нам даже не нужно его указывать в `Cargo.toml`, т.к Cargo сам заберет последний коммит.

Когда мы будем готовы выпустить новую версию библиотеки, Cargo может заново просчитать зависимости и обновить их для нас:

```shell
$ cargo update           # updates all dependencies
$ cargo update -p rand  # updates just “rand”
```

Эта команда создаст новый `Cargo.lock` с новой информацией о версиях зависимостей.
Обратите внимания, что аргумент для `cargo update` является
[идентификатор пакета](pkgid-spec.html) и `rand` это сокращенная запись идентификатора.

# Тесты

Cargo запустит ваши тесты с помощью команды `cargo test`. Cargo запускает тесты из двух мест: из вашей `src` директории, а так же в директории `tests/`.
Тесты в ваших `src` файла должны быть юнит тестами, а в папке `tests/` должны находиться интеграционные тесты. Таким образом, вам необходимо импортировать ваши контейнеры в интеграционные тесты.

Давайте рассмотрим пример запуска `cargo test` в нашем проекте, в котором, на данный момент, нет тестов:

<pre><code class="language-shell"><span class="gp">$</span> cargo test
<span style="font-weight: bold"
class="s1">   Compiling</span> rand v0.1.0 (https://github.com/rust-lang-nursery/rand.git#9f35b8e)
<span style="font-weight: bold"
class="s1">   Compiling</span> hello_world v0.1.0 (file:///path/to/project/hello_world)
<span style="font-weight: bold"
class="s1">     Running</span> target/test/hello_world-9c2b65bbb79eabce

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
</code></pre>

Если в вашем проекте есть тесты, вы должны увидеть вывод с правильным количеством тестов.

Вы так же можете запустить определенные тесты, передавая фильтр:

<pre><code class="language-shell"><span class="gp">$</span> cargo test foo
</code></pre>

Эта команда запустит все тесты, у которых есть `foo` в название.

`cargo test` может проводить дополнительные проверки. Например, скомпилирует все примеры, которые вы добавите и протестирует примеры в вашей документации. Более подробно можно прочитать в [разделе тестирования][testing] документации по языку программирования Rust.

[testing]: https://doc.rust-lang.org/book/testing.html

## Travis CI

Вы можете тестировать ваш проект с помощью Travis CI. Пример `.travis.yml` файла:

```
language: rust
rust:
  - stable
  - beta
  - nightly
matrix:
  allow_failures:
    - rust: nightly
```

В данном случае ваш код будет протестирован на всех трех доступных ветках Rust, но все ошибки сборки на nightly сборке не приведет к ошибке всего билда. Пожалуйста, ознакомьтесь с [документацией Travis CI для языка Rust](https://docs.travis-ci.com/user/languages/rust/) чтобы получить более подробную информацию.

# Что дальше?

Теперь, когда у вас есть представления, как использовать cargo, как создать свой первый контейнер, вам будет интересно почитать следующее:

* [Как опубликовать ваш контейнер на crates.io](crates-io.html)
* [Все возможные способы указания зависимостей](specifying-dependencies.html)
* [Узнать подробнее о том, что можно включить в манифест `Cargo.toml`](manifest.html)
