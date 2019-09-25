% Cargo - менеджер пакетов для языка программирования Rust.

# Установка

Самый простой способ установить Cargo, это скачать последнюю стабильную версию Rust
используя `rustup` скрипт:

```shell
$ curl -sSf https://static.rust-lang.org/rustup.sh | sh
```

После выполнения данного скрипта вы получите последнюю стабильную версию Rust для вашей платформы, а так же последнюю версию Cargo.

Если вы используете операционную систему Windows, вы можете скачать установщики последней стабильной версии Rust и ночную сборку Cargo. 32-х битная версия ([Rust](https://static.rust-lang.org/dist/rust-1.0.0-i686-pc-windows-gnu.msi)
и [Cargo](https://static.rust-lang.org/cargo-dist/cargo-nightly-i686-pc-windows-gnu.tar.gz)) или 64-х битная версия ([Rust](https://static.rust-lang.org/dist/rust-1.0.0-x86_64-pc-windows-gnu.msi) и [Cargo](https://static.rust-lang.org/cargo-dist/cargo-nightly-x86_64-pc-windows-gnu.tar.gz))

Вы так же можете собрать Cargo из исходного кода.

Чтобы убедиться, что установка прошла успешно, можно воспользоваться командой, которая выводит версию Cargo:
```shell
$ cargo --version
```

# Давайте начнем

Чтобы создать новый проект при помощи Cargo, необходимо воспользоваться командой `cargo new`:

```shell
$ cargo new hello_world --bin
```

Мы передали аргумент `--bin`, потому что мы создаем исполняемую программу: если мы
решим создать библиотеку, то этот аргумент необходимо убрать.

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

Это все, что нам необходимо для начала. Первым делом давайте посмотрим, что за файл `Cargo.toml`:

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

<pre><code class="language-shell">$ cargo build
<span style="font-weight: bold"
class="s1">   Compiling</span> hello_world v0.1.0 (file:///path/to/project/hello_world)</code></pre>

А потом запустим:

```shell
$ ./target/debug/hello_world
Hello, world!
```

Вы так же можете использовать `cargo run`, чтобы скомпилировать и запустить проект. Все за одну команду:

<pre><code class="language-shell">$ cargo run
<span style="font-weight: bold"
class="s1">     Fresh</span> hello_world v0.1.0 (file:///path/to/project/hello_world)
<span style="font-weight: bold"
class="s1">   Running</span> `target/hello_world`
Hello, world!</code></pre>

# Двигаемся дальше

Чтобы получить более подробную информацию о использование Cargo, ознакомьтесь с [Руководством по Cargo](guide.html)
