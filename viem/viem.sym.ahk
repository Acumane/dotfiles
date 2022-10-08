#NoEnv
#NoTrayIcon
#SingleInstance Force
SendMode Input

#Hotstring ? O
#Hotstring EndChars `n`t	; complete on Tab, Enter only

Suspend On
;########  SYMBOLS  ########

;—— Super/subscript —————
::^0::⁰
::^1::¹
::^2::²
::^3::³
::^n::ⁿ
::_0::₀
::_1::₁
::_2::₂
::^n+1::ⁿ⁺¹
::^n-1::ⁿ⁻¹
::_n+1::ₙ₊₁
::_n-1::ₙ₋₁

;—— Connectives —————————
::->::→
::—>::→
::implies::→
::then::→
::<->::↔
::iff::↔
::bicon::↔
::<—>::↔
::<=>::⇔
::&::∧
::and::∧
::^::∧
::|::∨
::or::∨
::v::∨
::xor::⊕
::!::¬
::~::¬
::not::¬

;—— Quantifiers —————————
::@::∀
::forall::∀
::?::∃
::exists::∃
::!?::∄
::!exists::∄

;—— Sets ————————————————
::intersect::∩
::subset::⊂
::supset::⊃
::union::∪
::comp::̅
::null::∅
::empty::∅
::elem::∈
::!elem::∉
::<=::≤
::leq::≤
::>=::≥
::geq::≥

;—— Identities ——————————
::!=::≠
::~=::≈
::approx::≈
::~==::≅
::cong::≅
::===::≡
::equiv::≡

;—— Logic ———————————————

::so::∴
::such::꞉
::col::꞉
::1::⊤
::taut::⊤
::0::⊥ 
::con::⊥

;—— Greek ———————————————
::alpha::α
::beta::β
::delta::Δ
:C:theta::θ
:C:Theta::Θ
::lambda::λ
::mu::μ
::sigma::Σ
::pi::π
::omega::Ω
::grad::∇
::nabla::∇

;—— etc —————————————————
::sqrt::√
::deg::°
::perp::⊥
::orth::⊥
::cross::×
::*::·
::dot::·
::dots::⋯
::inf::∞
::tm::™
::<::⟨
::>::⟩

;—— accented ————————————
::e/::é
::..o::ö
::~n::ñ

;—— abbreviations ———————
::aka::a.k.a.
::eg::e.g.
::ie::i.e.