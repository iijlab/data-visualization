### A Pluto.jl notebook ###
# v0.20.3

#> [frontmatter]
#> title = "Lusail Stadium Qatar"
#> description = "Algorithmic Design Project"

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 6931af5b-70ce-499e-ab87-106e9583f1b3
using Pkg

# ╔═╡ f6595c53-4db5-4ba8-9d20-d6b0214475f3
# ╠═╡ show_logs = false
Pkg.add(url="https://github.com/aptmcl/KhepriBase.jl")

# ╔═╡ ef9d3d71-3129-4479-bdd6-f750e7ce14b4
# ╠═╡ show_logs = false
Pkg.add(url="https://github.com/aptmcl/KhepriAutoCAD.jl")

# ╔═╡ 9ea9a5a2-9951-429f-a772-5021b1714386
# ╠═╡ show_logs = false
Pkg.add(["Plots", "Images", "PlutoUI"])

# ╔═╡ 2a7d6543-38c8-4a83-a940-2455eba324ac
using Plots: plot, surface, contour

# ╔═╡ a3ec0de8-2a18-4ddb-a7cf-d8b14fd2027f
using Images, PlutoUI, KhepriAutoCAD

# ╔═╡ 5945f0a5-066d-4d28-93d2-926b6e3b014b
md"# Lusail Stadium, Qatar
Algorithmic Design Project Adaptation | by Renata Castelo Branco"

# ╔═╡ 336fe6af-7ea8-44b2-add3-d45733eff681
md"### Original Architecture Project

The Lusail Stadium is the largest in Qatar and was designed by Foster + Partners for the 2022 FIFA World Cup. In a creative crossing of heritage-based inspirations, which included traditional arabe bowls and vessels, as well as Islamic lanterns, the building takes the shape of a golden cup with triangular perforations on the façade. The matrix of perforations mirrors the inner truss structure supporting the façade and the openings dictate the amount of natural light flowing into the galleries. In order to match the sinuous movement of the cup, the roof structure is shaped like a pringle and is composed of plastic membranes distributed in a radial pattern."

# ╔═╡ 9a62eced-0aed-4ad5-9931-f5873d9d542c
md"### Algorithmic Design Adaptation

This program is a parametric interpretation of the original architecture design, modeled using the Khepri algorithmic design tool."

# ╔═╡ 80b3e1db-a2f3-4336-a4de-685122de4c99
md"### Notes on using this Notebook
Khepri generates models in a multiplicity of tools. From the pool of 3D modeling tools available, this notebook uses AutoCAD. This means that, in order to visualize the geometric models, you'll need to install Autodesk's AutoCAD.

Since geometry-generation tests are heavy and may take long depending on the hardware used, every geometry-generation test is controlled by a PlutoUI toggle. Users may choose to turn specific tests on and off at each moment, benefiting from Pluto's interactivity without compromising performance.

**Beware:** when toggling on any geometry generation test, the notebook (more specifically, the Khepri package) will automatically try to launch AutoCAD. After establishing the connection with the tool once, the communication channel will remain open for the remaining tests. For further reading on Khepri's installation and tool connection refer to: _https://algorithmicdesign.github.io/tools/khepri.html_"

# ╔═╡ b5c47c9f-408c-41a0-b389-87eabd45c52c
md"## **Formalities**
### Packages"

# ╔═╡ 73f2da10-c2c7-45e4-a9a5-5138ff4590e3
md"### Settings"

# ╔═╡ 44b45f73-95d9-449a-abb6-9f4d92538cd3
TableOfContents(title="Lusail Stadium", depth=5, aside=true)

# ╔═╡ 33dfede5-1c9a-4156-b1dd-82bf1531df89
run_test(f, toggle=true) = toggle ? f() : nothing

# ╔═╡ c7a0d341-8aa3-4af6-a585-c86d7d42eaf2
md"## **Geometry Modeling**
### Bowl matrix
Creation of the bowl point matrix"

# ╔═╡ f6385204-4170-4deb-94c4-1e1b90b2666d
md"
#### Sinusoid

$f(t) = \alpha \cdot \sin(t \cdot \omega + \phi)$

* α = amplitude
* ω = frequency
* ϕ = phase
"

# ╔═╡ 17b1711b-6546-463a-ba49-e44df454ba78
sinusoid(α, ω, ϕ, t) = α * sin(ω * t + ϕ)

# ╔═╡ a7b9c225-90c7-4760-b0f2-4e11d059eb86
md" **Interactive test**

* α1 = $(@bind α1 Slider(1:20;show_value=true))
* ω1 = $(@bind ω1 Slider(1:0.1:5;show_value=true))
* ϕ1 = $(@bind ϕ1 Slider(0:5;show_value=true))

* α2 = $(@bind α2 Slider(1:20;show_value=true))
* ω2 = $(@bind ω2 Slider(1:0.1:5;show_value=true))
* ϕ2 = $(@bind ϕ2 Slider(0:5;show_value=true))
"

# ╔═╡ 7e4d3e68-99bf-424f-892f-dffe10d781f1
let x = range(0, 2π, length=50)
    y1 = sinusoid.(α1, ω1, ϕ1, x)
    y2 = sinusoid.(α2, ω2, ϕ2, x)
    plot(x, [y1 y2], title="Sinusoid", label=["sin 1" "sin 2"], linewidth=2)
end

# ╔═╡ 0ccf218f-f381-4d8d-8005-352faf1fb030
md"
**Period and frequency**

- T $\rightarrow$ period (2π if ω=1)
- T = 2π/ω $\equiv$ ω = 2π/T
- we want a period equivalent to the bowl's height
- T = h, ergo ω = 2π/h
- and we want something around 70% of the sinusoid's cycle up until π in that period
- ergo ω = .7π/h
"

# ╔═╡ f2dde536-335b-46e2-9fa1-62f62ef91791
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/bowl_frequency.png") |> load

# ╔═╡ 160cbe02-943d-4091-a003-f6199b1c260b
md"#### 2 separate sinusoids"

# ╔═╡ 5f4c1d1b-ac76-4f0a-ba05-d1f556c6a578
""" Bowl based on an h-dependent sinusoid, which influences each floor's radius. """
bowl_pts_h_sin(p, r, r_amp, h, n, m) =
    map_division((ϕ, h0) -> p + vcyl(r + r_amp * sin(0.7π / h * h0), ϕ, h0),
        # radius' base frequency: .7π in a period of h_max
        0, 2π, n,
        0, h, m)

# ╔═╡ ed37e6c2-24d6-4a30-b08c-74024fadbc89
md" ▶ Generate bowl matrix lines $(@bind bowl_pts_h_sin_test CheckBox(default=false))"

# ╔═╡ b550b52c-1186-4e51-82fb-08101a5cc541
run_test(bowl_pts_h_sin_test) do
    delete_all_shapes()
    map(spline, bowl_pts_h_sin(u0(), 20, 5, 10, 100, 10))
end

# ╔═╡ 25a28cb0-e507-430f-ba7a-d633d12ee50b
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bowl_1_H_dependent_sinusoid.png") |> load

# ╔═╡ 7b9b03f0-0ba1-40b8-b24e-9b848b15b6b7
""" Bowl based on a ϕ-dependent sinusoid, pringle effect along the rim. \\
ω = 2 for the pringle effect -> two loops within 2π. """
bowl_pts_ϕ_sin(p, r, h, n, m) =
    map_division((h0, ϕ) -> p + vcyl(r, ϕ, h0 + sin(2ϕ)),
        # heights' base frequency: 2 loops in a period of 2π
        0, h, m,
        0, 2π, n)

# ╔═╡ 8cef0e25-55ea-46eb-b983-01c0d7455432
md" ▶ Generate bowl matrix lines $(@bind bowl_pts_ϕ_sin_test CheckBox(default=false))"

# ╔═╡ 2fbf81d4-a312-4f84-aad3-0d55c90240a4
run_test(bowl_pts_ϕ_sin_test) do
    delete_all_shapes()
    map(spline, bowl_pts_ϕ_sin(u0(), 20, 10, 100, 10))
end

# ╔═╡ 28bb90d6-4480-4c4c-9b9b-a8c17adefdb2
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bowl_2.1_phi_sinusoid.png") |> load

# ╔═╡ ba2d310c-7507-4dee-a0db-35a54b6410bd
""" Bowl based on a ϕ-dependent sinusoid + h-dependent amplitude, growing with each floor. \\
Currently using 20% of the height dimension as the impact factor for the sinusoid's amplitude. """
bowl_pts_ϕh_sin(p, r, h, n, m) =
    map_division((h0, ϕ) -> p + vcyl(r, ϕ, h0 + 0.2h0 * sin(2ϕ)),
        # heights' base frequency: 2 loops in a period of 2π
        0, h, m,
        0, 2π, n)

# ╔═╡ 6a69e887-dc18-4ce2-a6d7-afdd2112470c
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/bowl_amplitude.png") |> load

# ╔═╡ 9b00f0a1-ec90-4d18-93b0-c08e7ef16f8a
md" ▶ Generate bowl matrix lines $(@bind bowl_pts_ϕh_sin_test CheckBox(default=false))"

# ╔═╡ d85bd24b-5658-4319-8a82-6ba02408aa33
run_test(bowl_pts_ϕh_sin_test) do
    delete_all_shapes()
    map(spline, bowl_pts_ϕh_sin(u0(), 20, 10, 100, 10))
end

# ╔═╡ e4fa867a-19be-4c2b-a0bc-1cdeaae010a6
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bowl_2.2_phi_sinusoid_c_amp.png") |> load

# ╔═╡ 634e6b43-be34-46d0-8dc1-e06adfcbf658
md"#### 2 joint sinusoids"

# ╔═╡ 2c81c635-df9c-49c4-bcac-dbfd24737261
md"
**Parameters**

* p = bowl center at the base
* r = bowl radius
* r amp = bowl curvature amplitude
* h max = bowl height
* ωh = frequency in height
* ωϕ = frequency around the bowl (from 0 to 2π)
* n = points around the bowl (from 0 to 2π)
* m = points in height on the bowl"

# ╔═╡ 252e33f6-de0b-4c6c-8ee9-1859de068857
""" Bowl matrix points joining both sinusoids (h-dependent for the radius and ϕ-dependent amplitude). """
bowl_pts_double_sin(p, r, r_amp, h_max, ωh, ωϕ, n, m) =
    map_division((h, ϕ) -> p + vcyl(r + sinusoid(r_amp, ωh * 0.7π / h_max, 0, h),
            # ωh: variation parameter
            ϕ,
            h + sinusoid(0.2h, ωϕ, 0, ϕ)),
        # ωϕ: variation parameter
        0, h_max, m,
        0, 2π, n)

# ╔═╡ a56aba0e-90dc-405b-907b-7a7e09dc1ec6
md" ▶ Generate bowl matrix lines $(@bind bowl_pts_double_sin_test CheckBox(default=false))"

# ╔═╡ 631789f0-4dc0-4eb8-9dcd-a8ac32892b69
run_test(bowl_pts_double_sin_test) do
    delete_all_shapes()
    map(spline, bowl_pts_double_sin(u0(), 20, 5, 10, 1, 2, 100, 10))
    map(spline, bowl_pts_double_sin(u0(), 20, 5, 20, 2, 4, 100, 10))
    map(spline, bowl_pts_double_sin(u0(), 20, 30, 10, 1 / 2, 8, 100, 10))
    map(spline, bowl_pts_double_sin(u0(), 20, 5, 10, 1, 3, 100, 10))
end

# ╔═╡ e1cc3186-00e7-4560-9425-71241139c6c4
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bowl_3_join_two_sinusoids.png") |> load

# ╔═╡ c651d012-0eaa-4954-976b-b11b524a6bb4
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bowl_3_var_a.png") |> load

# ╔═╡ 102de52c-b5b7-4953-99be-a97352b50731
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bowl_3_var_b.png") |> load

# ╔═╡ bb2bdb18-ca44-4d18-98e5-9708473ee046
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bowl_3_var_c.png") |> load

# ╔═╡ ac4d4c31-090b-44b3-8e7a-16da651c4d7e
md"#### Rotate bowl points"

# ╔═╡ 21e81955-0b0e-4e1f-adcf-db79a6749a08
""" Converts matrix rows into columns. \\
A matrix, in the Khepri context, is a vector of vectors. """
transpose_matrix(matrix) = [[row[i] for row in matrix] for i in 1:length(matrix[1])]

# ╔═╡ 485101b9-5ddd-4092-8f0e-3ef4313846c5
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/transposed_matrix.png") |> load

# ╔═╡ f21cd0a3-de3c-4aa8-be4b-f3ad4a94867f
transpose_matrix([1:4, 1:4, 1:4])

# ╔═╡ 8215cb70-adc3-4a62-9797-a2a6a9462ea3
""" Slanted bowl points matrix with Δϕ increment on each floor. """
bowl_pts(p, r, r_amp, h_max, ωh, ωϕ, n, m, n_bool=true) =
    let hs = division(0, h_max, m)
        ϕi = π * m / n # right angle increment for (somewhat) equilateral triangles
        Δϕs = division(0, ϕi, m)
        map_division((i, ϕ) ->
                p + vcyl(r + sinusoid(r_amp, ωh * 0.7π / h_max, 0, hs[Int(i + 1)]),
                    # ωh: variation parameter
                    -ϕi + Δϕs[Int(i + 1)] + ϕ,
                    hs[Int(i + 1)] + sinusoid(0.2hs[Int(i + 1)], ωϕ, 0, ϕ)),
            # ωϕ: variation parameter
            0, m, m,
            0, 2π, n, n_bool)
    end

# ╔═╡ 1c0ce485-341c-4d84-b3ca-d68c10aa6202
md" ▶ Generate bowl matrix lines $(@bind bowl_pts_test CheckBox(default=false))"

# ╔═╡ a8fb896e-e4bd-4643-bc26-b5d8c2548ee1
run_test(bowl_pts_test) do
    delete_all_shapes()
    map(spline, transpose_matrix(bowl_pts(u0(), 20, 5, 10, 1, 2, 100, 10)))
    map(spline, bowl_pts(u0(), 20, 5, 10, 1, 2, 100, 10, false))
end

# ╔═╡ 6505c491-f53d-4c4c-977d-ae6565d60c5f
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bowl_4_rotate_phi.png") |> load

# ╔═╡ 7782525b-f6b5-4424-9995-3c91e9c59a06
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bowl_4_rotate_transpose.png") |> load

# ╔═╡ 2564b841-1b1b-4fb3-ac21-6bfa55c6f39a
md"### Roof matrix
Creation of the pringle roof point matrix"

# ╔═╡ d67f2ae3-f9c5-4c43-8fbd-441c04fdb8e6
md"
**Parameters**

* p = roof's center
* r min = roof's whole radius
* r base = roof's outer radius $\equiv$ bowl's base radius
* r amp = bowl curvature amplitude (influences the radius of the top row)
* h bowl = bowl height
* ωh = bowl frequency, needed to calculate the maximum radius
* ωϕ = frequency around the roof (from 0 to 2π)
* Δϕ = initial angle for iteration along n dimension
* n = points around the roof (from 0 to 2π)
* m = points along the roof's radius

**Local variables**

* r end = roof's maximum radius $\equiv$ last bowl radius value (at h-bowl height) $\equiv$ r-base + sinusoid movement with r-amp as amplitude"

# ╔═╡ c137ef22-abfc-4ec5-a7f6-30f6da9d7e69
straight_roof_pts(p, r_min, r_base, r_amp, h_bowl, ωh, ωϕ, n, m) =
    let r_end = r_base + sinusoid(r_amp, ωh * 0.7π / h_bowl, 0, h_bowl)
        rs = division(r_min, r_end, m)
        amps = division(0, 0.2h_bowl, m)
        ϕi = π * m / n
        Δϕs = division(0, ϕi, m)
        map_division((i, ϕ) -> p + vcyl(rs[Int(i + 1)],
                -ϕi + Δϕs[Int(i + 1)] + ϕ,
                sinusoid(amps[Int(i + 1)], 2ωϕ, 0, ϕ)),
            # ωh - variation parameter
            # radius' base frequency - .7π in a period of h_max
            0, m, m,
            0, 2π, n, false)
    end

# ╔═╡ efaffbf1-32ea-4528-a32f-ee71b95c7ee9
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/pringle_.png") |> load

# ╔═╡ 9b0b8eac-890d-4890-aa7e-74cef3970211
md" ▶ Generate roof matrix lines/surface $(@bind straight_roof_pts_test CheckBox(default=false))"

# ╔═╡ 03795ef0-5b26-459e-a914-ded3d65d5376
run_test(straight_roof_pts_test) do
    delete_all_shapes()
    map(spline, straight_roof_pts(z(10), 5, 20, 5, 10, 1, 1, 100, 10))
    surface_grid(straight_roof_pts(z(10), 5, 20, 5, 10, 1, 1, 100, 10))
end

# ╔═╡ e33c78e8-4669-4d51-ac75-6d654ee50256
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/roof_pts_no_rotation.png") |> load

# ╔═╡ 29547eba-08f8-4d55-b5ad-ed9a144b6faf
md"#### Rotated roof points"

# ╔═╡ a63b26d0-b0ec-42b1-b5be-3e7eca7a242d
""" Slanted roof points. Δϕ increment to each row to create diamonds instead of squares. """
roof_pts(p, r_min, r_base, r_amp, h_bowl, ωh, ωϕ, n, m, bool=false) =
    let r_end = r_base + sinusoid(r_amp, ωh * 0.7π / h_bowl, 0, h_bowl)
        rs = division(r_min, r_end, m)
        amps = division(0, 0.2h_bowl, m)
        ϕi = π * m / n # compensate for the rotation in the end to match the bowl (-ϕi)
        Δϕs = division(0, ϕi, m)
        map_division((i, ϕ) -> p + vcyl(rs[Int(i + 1)],
                -ϕi + Δϕs[Int(i + 1)] + ϕ,
                sinusoid(amps[Int(i + 1)], ωϕ, 0, ϕ)),
            # ωh - variation parameter
            # radius' base frequency - .7π in a period of h_max
            0, m, m,
            0, 2π, n, bool)
    end

# ╔═╡ 36a6b9f6-dab0-4638-8969-c6bac473d520
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/roof_matrix.png") |> load

# ╔═╡ 49314522-210d-40a8-a540-91c0754316bf
md" ▶ Generate roof matrix points/lines $(@bind roof_pts_test CheckBox(default=false))"

# ╔═╡ c64f722b-8c41-485e-8526-f02b96bd24af
run_test(roof_pts_test) do
    delete_all_shapes()
    map(ps -> sphere.(ps, 0.1), roof_pts(z(10), 5, 20, 5, 10, 1, 1, 20, 10))
    map(spline, roof_pts(z(10), 5, 20, 5, 10, 1, 1, 20, 10))
    map(spline, transpose_matrix(roof_pts(z(10), 5, 20, 5, 10, 1, 1, 20, 10)))
end

# ╔═╡ 587d8649-509f-4cbc-97d2-494b2016b193
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/roof_pts.png") |> load

# ╔═╡ 4dea6eb9-d9bf-4915-af1e-768827c44152
md"### Complete Shell Test"

# ╔═╡ e055f3c2-5f12-4735-93ee-57eb549b34b8
"""
### Parameters
p = bowl center at the base \\
r min = roof whole radius \\
r = bowl radius \\
r amp = bowl curvature amplitude \\
h = bowl height \\
ωh = frequency in height \\
ωϕ = frequency around the bowl (from 0 to 2π) \\
nb = n points around the bowl (from 0 to 2π) \\
mb = m points in height on the bowl \\
nr = nr points around the roof (from 0 to 2π) \\
mr = mr points along the radius on the roof
"""
shell(p, r_min, r, r_amp, h, ωh, ωϕ, nb, mb, nr, mr) =
    [bowl_pts(p, r, r_amp, h, ωh, ωϕ, nb, mb),
        roof_pts(p + vz(h), r_min, r, r_amp, h, ωh, ωϕ, nr, mr)]

# ╔═╡ 8e4354c1-4c2a-4baf-b287-4c3650d2597d
md" **Interactive test**

* r = $(@bind rt Slider(10:40;show_value=true))
* r min = $(@bind r_min_t Slider(0:9;show_value=true))
* r amp = $(@bind r_amp_t Slider(1:10;show_value=true))
* h = $(@bind ht Slider(10:30;show_value=true))
* ωh = $(@bind ωht Slider(1:.1:10;show_value=true))
* ωϕ = $(@bind ωϕt Slider(1:.1:10;show_value=true))
* mb = $(@bind mbt Slider(10:20;show_value=true))
* mr = $(@bind mrt Slider(5:10;show_value=true))
"

# ╔═╡ f53bb5e9-e82c-4076-9844-cb1a3a704329
let pts_cyl = shell(u0(), r_min_t, rt, r_amp_t, ht, ωht, ωϕt, 100, mbt, 100, mrt)
    pts_bowl = vcat(pts_cyl[1]...)
    pts_roof = vcat(pts_cyl[2]...)
    b_xs, b_ys, b_zs = cx.(pts_bowl), cy.(pts_bowl), cz.(pts_bowl)
    r_xs, r_ys, r_zs = cx.(pts_roof), cy.(pts_roof), cz.(pts_roof)
    plot([b_xs, r_xs], [b_ys, r_ys], [b_zs, r_zs],
        title="Lusail Shell", label=["Bowl" "Roof"])
end

# ╔═╡ 8c02a388-badf-4a61-9d56-98fb6f2ec88b
md" ▶ Generate shell matrix lines $(@bind shell_test CheckBox(default=false))"

# ╔═╡ d0a4c6d2-50f6-4dc0-bd04-07a185aed377
run_test(shell_test) do
    delete_all_shapes()
    map(ptss -> spline.(ptss), shell(u0(), 5, 20, 5, 10, 1, 2, 100, 10, 66, 10))
    map(ptss -> spline.(ptss), shell(x(90), 5, 40, 5, 20, 2, 4, 100, 10, 100, 10))
    map(ptss -> spline.(ptss), shell(x(200), 20, 20, 30, 10, 1 / 2, 8, 100, 10, 66, 10))
end

# ╔═╡ 9284c7ea-4a54-41c5-bdad-5fcc9656681b
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/shell.png") |> load

# ╔═╡ 5536357c-c701-4f71-91d0-b5dc33e3fb8a
md"### Iterate functions
#### Arrays
Iterate over arrays"

# ╔═╡ dff6ad93-da7a-4df9-9590-18fe82355307
""" Sends N number of elements from the beginning to the end of the array (dir=true)
or from the end to the beginning (dir=false). """
rotate_array(arr, n, dir=true) = # dir -> fold left or right ?
    n == 0 ? arr :
    (dir ? rotate_array(vcat(arr[2:end], arr[1]), n - 1) : # true -> forward
     rotate_array(vcat(arr[end], arr[1:end-1]), n - 1, false))
# false -> backward

# ╔═╡ 30e4f849-306d-4d89-b727-dda507d8d93a
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/rotate_array.png") |> load

# ╔═╡ a955e573-9244-48a2-bc37-e1f42625a9a5
let a = [1, 2, 3, 4, 5, 6, 7, 8]
    b = rotate_array(a, 1)
    c = rotate_array(a, 4)
    d = rotate_array(a, 1, false)
    e = rotate_array(a, 2, false)
    f = rotate_array(a, 4, false)
    a, b, c, d, e, f
end

# ╔═╡ 04e31783-6d73-4b0f-8eab-f6a05e0292a6
""" Applies an array rotation to each array of the matrix, with increasing N
(number of elements moved in each array). """
rotate_matrix(ptss, dir=true) =
    [rotate_array(pts, n, dir) for (pts, n) in zip(ptss, 0:length(ptss)-1)]

# ╔═╡ 1a09acf7-8f9f-4537-aae3-f2022eff0216
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/rotate_matrix.png") |> load

# ╔═╡ 43abb92f-cd29-404d-9058-61662a57d514
let a = [1, 2, 3, 4, 5, 6]
    b = rotate_matrix([a for i in 0:3])
    c = rotate_matrix([a for i in 0:3], false)
    d = rotate_matrix([a for i in 0:5], false)
    b, c, d
end

# ╔═╡ 9075bdd9-cc0d-4cba-adda-82ea9aee6ccf
""" Rotates 2 arrays at a time following a (0,1,1,2,2,3,3,4,4...) scheme for the N parameter. """
custom_rotate_matrix(ptss, n, dir=true) =
    length(ptss) == 2 ?
    [rotate_array(ptss[1], n, dir), rotate_array(ptss[2], n + 1, dir)] :
    length(ptss) == 1 ? [rotate_array(ptss[1], n, dir)] :
    [rotate_array(ptss[1], n, dir),
        rotate_array(ptss[2], n + 1, dir),
        custom_rotate_matrix(ptss[3:end], n + 1, dir)...]

# ╔═╡ f8a7f4bc-c573-4ea7-88fa-52fa7cd34b8d
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/costum_rotate.png") |> load

# ╔═╡ 864c50d9-28c3-4e2b-9cb1-21fb0dd175d0
let a = [1, 2, 3, 4, 5, 6]
    b = custom_rotate_matrix([a for i in 0:10], 0)
    c = custom_rotate_matrix([a for i in 0:11], 0)
    b, c
end

# ╔═╡ 1b7c984a-3031-4a6f-8107-5a970aca14db
""" Maps function f over sets of 4 points (diamonds) in 3 arrays (as, bs, cs). \\
Meant to iterate the bubble function over the Lusail roof matrix. """
iterate_subset(f, as, bs, cs) =
    for (a, b, c, b1) in zip(as, bs, cs, bs[2:end])
        f(a, b, c, b1)
    end

# ╔═╡ b35bf970-9569-4ca6-bbb2-412bb9e2bac8
""" Maps function f over all sets of 4 points (diamonds) in the matrix,
by providing iterate_subset with 3 arrays at a time. \\
Meant to iterate the bubble function over the Lusail roof matrix. """
iterate_diamonds(f, ptss) =
    length(ptss) == 3 ? iterate_subset(f, ptss[1:3]...) : # last set of 3 arrays
    length(ptss) == 2 ? nothing : # if there are only two left, do nothing. We shall place triamonds, not diamonds here.
    begin
        iterate_subset(f, ptss[1:3]...) # as, bs, cs
        iterate_diamonds(f, ptss[3:end]) # cs, ds, fs ...
    end

# ╔═╡ 838861a6-f323-4446-87d3-e2b5d78282f8
""" Maps function f over 2 arrays: as and bs. \\
Meant for the first/last two arrays of the Lusail roof matrix,
where triangular bubbles are placed, instead of diamond-shaped ones. """
iterate_triamonds(f, as, bs, sgn=identity) =
    [f(a, b, a1, sgn) for (a, b, a1) in zip(as, bs, as[2:end])]

# ╔═╡ 36bdb831-86c0-4850-9f73-88cf5df90b24
""" Makes new array with odd indexes only. """
get_odds(arr) = arr == [] ? [] : [arr[1]; get_odds(arr[3:end])]

# ╔═╡ 1b0f4013-665c-442c-a08d-5c5e140b2dee
""" Makes new array with even indexes only. """
get_evens(arr) = get_odds(arr[2:end])

# ╔═╡ 95fa774e-ee8b-48e1-bb60-553c71ee64b8
begin
    get_odds([1, 2, 3, 4, 5, 6]),
    get_odds([1, 2, 3, 4, 5]),
    get_evens([1, 2, 3, 4, 5, 6]),
    get_evens([1, 2, 3, 4, 5])
end

# ╔═╡ 58623144-6bc3-410f-80c5-2746ac081142
""" Reduces the number of elements in an array by skipping elements with a step defined by parameter N. """
skip_reduce(arr, n) = [arr[i] for i in 1:n:length(arr)]

# ╔═╡ 4595e96b-78fb-4d6c-847d-95e61f3109f6
let a = 0:20
    b = skip_reduce(a, 6)
    c = skip_reduce(a, 4)
    a, b, c
end

# ╔═╡ 2b2fd125-2dff-4c4d-a70e-54069630b104
""" Finds the highest number (below start) by which N is divisible. """
find_divisible_num(n, start) =
    n % start == 0 ? start : find_divisible_num(n, start - 1)

# ╔═╡ 3f75fd90-f596-49e9-a279-802839b36318
find_divisible_num(60, 10),
find_divisible_num(84, 10),
find_divisible_num(102, 10),
find_divisible_num(35, 10),
find_divisible_num(15, 10)

# ╔═╡ 2a70c776-f438-406c-b8c6-2e8fca5c889f
md"#### Geometry
Iterate geometry over point matrices
##### Façade triangles"

# ╔═╡ 2f860d64-2d0d-4b30-bc15-33000fb27826
""" From 3 locs in space, produces a triangular surface with a triangular hole in the middle. \\
Hole size depends on the f factor, which is a value from 0 (no hole) to 1 (no surface). """
trig_window(a, b, c, f=0.4) =
    let p = trig_center(a, b, c)
        KhepriBase.b_surface_polygon_with_holes(current_backend()[1],
            [a, b, c], [[intermediate_loc(p, a, f), intermediate_loc(p, b, f), intermediate_loc(p, c, f)]], -1)
    end

# ╔═╡ 97abe45e-e2db-4945-bf45-ece37d29a292
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/triangle.png") |> load

# ╔═╡ fe7e4243-88d0-4aec-977c-e182134a4db9
md" ▶ Generate triangular windows $(@bind trig_window_test CheckBox(default=false))"

# ╔═╡ 124916cb-1c1b-47bc-a84a-345ba089b898
run_test(trig_window_test) do
    delete_all_shapes()
    trig_window(u0(), x(2), xy(1, 2))
    trig_window(u0(), x(2), xy(1, 2), 0.1)
end

# ╔═╡ 25de6753-a73e-4582-aaa7-857cbd4fbf2b
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/window_trig.png") |> load

# ╔═╡ ca1db2b7-3413-4d2f-a1a7-c9684d08af16
""" Places two triangular windows in a quadrangle. \\
Default aperture factor = .4 """
trig_windows(p1, p2, p3, p4, f=0.4) =
    begin
        trig_window(p1, p2, p4, f)
        trig_window(p2, p3, p4, f)
    end

# ╔═╡ 33c592df-3a7d-408e-b9db-ae628630c7ef
md"##### Roof bubbles"

# ╔═╡ c5eabcfb-f3b6-49c1-bd40-860e6dea1b71
""" Makes an upward/downward-facing bubble over the diamond by lofting curves. \\
Up or down controlled by the sgn parameter to make up for the default direction of the normal vector. """
bubble(p1, p2, p3, p4, sgn=identity) =
    let c = quad_center(p1, p2, p3, p4)
        n = sgn(quad_normal(p1, p2, p3, p4))
        d = distance(p2, p4)
        loft([line(p2, p3, p4), spline(p2, c + n * d / 4, p4), line(p4, p1, p2)])
    end

# ╔═╡ 278086e6-5dc5-49a0-ab94-3f8bca36aeeb
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/bubbles.png") |> load

# ╔═╡ 56f12188-ed55-4a9a-94a9-f14d7f90f40e
""" Same as the diamond bubble, but for a triamond (3 points only). """
tri_blubble(a, b, a1, sgn=identity) =
    let pm = intermediate_loc(a, a1)
        bubble(pm, a, b, a1, sgn)
    end


# ╔═╡ 175814f6-359c-4dc2-9d6f-6d7125066b29
md"##### Truss structure"

# ╔═╡ 76dde91a-9968-40f6-8fd7-75aa30067297
facade_bar(a, b, r) = cylinder(a, r, b)
# maybe change to a triangular prism in the future

# ╔═╡ a72bc18f-8eba-41b7-bfc2-4835c19e45f0
bars(as, bs, r) = [facade_bar(a, b, r) for (a, b) in zip(as, bs)]

# ╔═╡ 4776df76-098b-4a02-b57f-5f1f5d3c247f
""" Receives an array of points and links them in sequence with bars, like a continuous bar. """
cont_bar(as, r) = bars(as, as[2:end], r)

# ╔═╡ 48aa4507-8646-407e-9ec3-242e85e9b6a2
""" Receives 2 arrays of points and links them with zigzag and cross bars. \\
The reinforced option adds an extra set of bars. \\
as should match bowl, bs should be inwards. """
planar_truss(as, bs, r, reinforced=true) =
    begin
        reinforced ? bars(as, bs, r) : bars(get_odds(as), get_odds(bs), r)
        map(i -> cont_bar(i, r), [as, bs])
        bars(get_odds(as), get_evens(bs), r)
        bars(get_odds(bs[2:end]), get_evens(as[2:end]), r)
    end

# ╔═╡ 931a160c-39f9-4f99-9e8a-f94f1c801361
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/planar_truss.png") |> load

# ╔═╡ 33f711c3-5626-4165-8a25-c921e12f34ef
md" ▶ Generate planar truss $(@bind planar_truss_test CheckBox(default=false))"

# ╔═╡ 1a86d434-6353-432f-95d7-1c6ac472d3c6
run_test(planar_truss_test) do
    delete_all_shapes()
    planar_truss(map_division(x, 0, 20, 10),
        map_division(x -> xy(x, 5), 0, 20, 10), 0.1)
    planar_truss(map_division(x, 0, 20, 10),
        map_division(x -> xy(x, 5), 0, 20, 10), 0.1, false)
end

# ╔═╡ accf60b6-c3cd-4b8b-9dee-553410568c0b
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/truss_planar.png") |> load

# ╔═╡ 535bc44f-4d17-408e-8d81-4168a380157b
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/truss_planar_reinforced.png") |> load

# ╔═╡ 2566bf52-5de9-4bb8-82f9-51bd1966650b
""" Receives 2 arrays of points and links them with cross and half zigzag bars \\
the last set differs (triangular shape instead). \\
Meant for 2 arrays with coincident first points. \\
as should match bowl, bs should be inwards. """
trig_truss(as, bs, r) =
    let m = intermediate_loc(as[end], bs[end])
        map(i -> cont_bar(i, r), [as, bs])
        bars(as[2:end], bs[2:end], r)
        bars(bs[2:end-2], as[3:end-1], r)
        facade_bar(as[end-1], m, r)
        facade_bar(bs[end-1], m, r)
    end

# ╔═╡ 222ef4ec-d907-4cc9-b463-5a5ca02bd91d
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/trig_truss.png") |> load

# ╔═╡ ef1f1a40-e42d-43c6-bc93-37e8728c555a
md" ▶ Generate triangular truss $(@bind trig_truss_test CheckBox(default=false))"

# ╔═╡ eb2c0ba9-5efe-455a-8c95-eb1b81ed0885
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/truss_trig.png") |> load

# ╔═╡ f9cf0031-2a9f-446e-8c80-705bf7d950a6
""" Receives 3 arrays of points and links them with bars in a star-like arrangement. """
star_truss(as, bs, cs, r) =
    begin
        map(i -> cont_bar(i, r), [as, bs, cs])
        bars(as, cs, r)
        bars(get_odds(as), get_odds(cs[3:end]), r)
        bars(get_odds(cs), get_odds(as[3:end]), r)
    end

# ╔═╡ 3a9aafff-0ce6-484d-9d62-8ffb998dbc08
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/star_truss.png") |> load

# ╔═╡ fd44a40c-32e1-41c1-a2b0-87791dffa8d4
md" ▶ Generate star truss $(@bind star_truss_test CheckBox(default=false))"

# ╔═╡ 8e4a0c60-4e15-433b-8f0d-95e890dea555
run_test(star_truss_test) do
    delete_all_shapes()
    star_truss(map_division(x, 0, 30, 10),
        map_division(x -> xy(x, 5), 0, 30, 10),
        map_division(x -> xy(x, 10), 0, 30, 10), 0.1)
end

# ╔═╡ ecb351b2-aff6-4bb3-a2d2-8c7b475128a5
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/truss_star.png") |> load

# ╔═╡ 8d9b35f8-7e0e-43e4-8ead-742cf59e3cfd
""" Receives 4 arrays of points and produces a spatial/3D truss structure. \\
as.z == aas.z && bs.z == bbs.z && as.z < bs.z """
space_truss(as, aas, bs, bbs, r) =
    let ams = map(intermediate_loc, as, aas)
        bms = map(intermediate_loc, bs, bbs)
        star_truss(as, ams, aas, r)
        star_truss(bs, bms, bbs, r)
        planar_truss(as, bs, r, false)
        planar_truss(aas, bbs, r, false)
        bars(ams, bms, r)
        bars(aas, bms, r)
        bars(as, bms, r)
    end

# ╔═╡ 7c67815e-1a59-4a7a-82c9-2839bd85e6fa
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/space_truss.png") |> load

# ╔═╡ 38dc97f3-5773-4735-806f-932158bd7c2f
md" ▶ Generate space truss $(@bind space_truss_test CheckBox(default=false))"

# ╔═╡ 1d763f04-fc17-4c5e-8854-197bfdda918e
run_test(space_truss_test) do
    delete_all_shapes()
    space_truss(map_division(x, 0, 30, 10),
        map_division(x -> xy(x, 10), 0, 30, 10),
        map_division(x -> xz(x, 5), 0, 30, 10),
        map_division(x -> xyz(x, 10, 5), 0, 30, 10), 0.1)
end

# ╔═╡ f9508fb4-5703-4087-b2e4-6fed3d04c78a
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/truss_spatial.png") |> load

# ╔═╡ bb757825-1cf7-4ebe-af49-15e2a253c8f5
md"### Map geometry onto matrices
#### Façade lattices"

# ╔═╡ 4363d786-5594-41cc-bf9b-a577f7719d93
md" **Parameters**
* p = bowl center at the base
* r = bowl radius
* r amp = bowl curvature amplitude
* h = bowl height
* ωh = frequency in height
* ωϕ = frequency around the bowl (from 0 to 2π)
* n = n points around the bowl (from 0 to 2π)
* m = m points in height on the bowl
* bar r = radius of the truss bars
"

# ╔═╡ efd74cc7-71b1-445b-91c5-e095e795ae9a
facade_panels(p, r, r_amp, h, ωh, ωϕ, n, m) =
    iterate_quads((p1, p2, p3, p4) -> trig_windows(p1, p2, p3, p4, 0.4),
        bowl_pts(p, r, r_amp, h, ωh, ωϕ, n, m))

# ╔═╡ 1215da5d-9e4f-4b7e-9622-7a4526577ca1
md" ▶ Generate façade panels $(@bind facade_panels_test CheckBox(default=false))"

# ╔═╡ 93e6ea83-9091-4a63-8621-6280dd536da5
run_test(facade_panels_test) do
    delete_all_shapes()
    facade_panels(u0(), 20, 5, 10, 1, 2, 100, 10)
    facade_panels(x(80), 20, 5, 10, 1, 4, 50, 10)
    facade_panels(x(160), 20, 5, 10, 1, 8, 50, 6)
end

# ╔═╡ cba784f9-f45d-46f6-aca3-07d20c812a97
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/facade_panels.png") |> load

# ╔═╡ 08dfa6a5-389c-4077-b075-2e955c4e57c2
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/panels.png") |> load

# ╔═╡ a1d8392d-413a-458d-ab04-7f43b77c8e6a
facade_bars(p, r, r_amp, h, ωh, ωϕ, n, m, bar_r) =
    let ptss = bowl_pts(p, r, r_amp, h, ωh, ωϕ, n, m)
        for (as, bs) in zip(ptss, ptss[2:end])
            bars(as, bs, bar_r)
            bars(bs, as[2:end], bar_r)
            cont_bar(as, bar_r)
        end
        bars(ptss[end], ptss[end][2:end], bar_r)
    end

# ╔═╡ bcd73f54-ef2c-466e-9c0f-d984b95d15a9
md" ▶ Generate façade bars $(@bind facade_bars_test CheckBox(default=false))"

# ╔═╡ db5b5c72-9287-459c-b847-d4c7b221c013
run_test(facade_bars_test) do
    delete_all_shapes()
    facade_bars(u0(), 20, 5, 10, 1, 2, 100, 10, 0.1)
    facade_bars(x(80), 20, 5, 10, 1, 4, 50, 10, 0.1)
    facade_bars(x(160), 20, 5, 10, 1, 8, 50, 6, 0.1)
end

# ╔═╡ 0c3a4e35-8379-44b7-87dd-164635ee4762
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/facade_bars.png") |> load

# ╔═╡ f7f2acab-7ec9-42c5-a748-57017d38ac2c
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bars.png") |> load

# ╔═╡ 0ae3325e-7401-4dbe-90de-f397dd2ac9c2
md"#### Façade truss"

# ╔═╡ 3937d4ad-a2cb-4a45-8924-c7b8209fcb69
md" **Parameters**
* truss func = truss function that will be mapped onto the matrix
* ptss bool = boolean value that decides the variation between matrices (radius or amplitude)
* p = bowl center at the base
* r = bowl radius
* r amp = bowl curvature amplitude
* h = bowl height
* ωh = frequency in height
* ωϕ = frequency around the bowl (from 0 to 2π)
* n = n points around the bowl (from 0 to 2π)
* m = m points in height on the bowl
* bar r = radius of the truss bars
* tw = width used for the planar truss (distance between matrices)
* div = subdivisions for n
* width = width used for the triangular truss (distance between matrices)
"

# ╔═╡ 3a83d392-a17d-495b-94d6-382cce2721fe
horizontal_truss(p, r, r_amp, h, ωh, ωϕ, n, m, bar_r, tw) =
    let m1 = round(Int, m / find_divisible_num(m + 1, 3))
        ptss(rad) = bowl_pts(p, rad, r_amp, h, ωh, ωϕ, n, m1)[1:end-2]
        ptss_a, ptss_b = ptss(r), ptss(r - tw)
        planar_truss.(ptss_a, ptss_b, bar_r)
    end

# ╔═╡ 3b90445d-fa36-4c71-8c1a-d53446721135
md" ▶ Generate horizontal truss $(@bind horizontal_truss_test CheckBox(default=false))"

# ╔═╡ 4a9bea24-a793-4937-b8ca-3cec0fceefef
run_test(horizontal_truss_test) do
    delete_all_shapes()
    horizontal_truss(u0(), 20, 5, 10, 1, 2, 100, 10, 0.05, 1)
end

# ╔═╡ 224d72d0-84f7-44bc-b2df-353af191506b
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/truss_horizontal_.png") |> load

# ╔═╡ fe6c46ca-839b-4614-a217-a840d91f4781
generic_vert_truss(truss_func, ptss_bool, p, r, r_amp,
    h, ωh, ωϕ, n, m, bar_r, tw, div, width) =
    let m1 = round(Int, m / find_divisible_num(m + 1, 3)) # m subdivision to 1/3 or more
        m_step = round(Int, m / m1)
        ptss(new_r) = ptss_bool ?
                      bowl_pts(p, new_r, r_amp, h, ωh, ωϕ, n, m, false)[1:end-m_step] :
                      bowl_pts(p, r, new_r, h, ωh, ωϕ, n, m, false)[1:end-m_step]
        (ptss_a, ptss_b) = ptss_bool ? (ptss(r), ptss(r - tw)) :
                           (ptss(r_amp), ptss(r_amp - width + tw))
        n_step = round(Int, n / div)
        reduced(mtx) = skip_reduce(transpose_matrix(mtx), n_step)
        ptss_a_dir1, ptss_b_dir1 = reduced(ptss_a), reduced(ptss_b)
        ptss_a_dir2 = reduced(rotate_matrix(ptss_a, false))
        ptss_b_dir2 = reduced(rotate_matrix(ptss_b, false))
        truss_func.(ptss_a_dir1, ptss_b_dir1, bar_r) # vertical lines anti-clockwise
        truss_func.(ptss_a_dir2, ptss_b_dir2, bar_r) # vertical lines clockwise
    end

# ╔═╡ e252f15f-e26c-402c-9f46-92f89cf326a4
vertical_truss(p, r, r_amp, h, ωh, ωϕ, n, m, bar_r, tw, ndiv) =
    generic_vert_truss(planar_truss, true,
        p, r, r_amp, h, ωh, ωϕ, n, m, bar_r, tw,
        find_divisible_num(n, ndiv), 0)
# n subdivision to 1/50 or more

# ╔═╡ 28ac9689-23da-40f6-bb0e-8d2f19eee1a4
md" ▶ Generate vertical truss $(@bind vertical_truss_test CheckBox(default=false))"

# ╔═╡ f115305e-6a23-48a2-80e0-bd340d158eae
run_test(vertical_truss_test) do
    delete_all_shapes()
    vertical_truss(u0(), 20, 5, 10, 1, 2, 100, 10, 0.05, 1, 50)
end

# ╔═╡ 57496a51-bf74-41d3-bb6a-f3722c20d27d
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/truss_vert_.png") |> load

# ╔═╡ 1ad90c37-3e5b-44a1-a5ac-be25f57ee45e
trig_truss(p, r, r_amp, h, ωh, ωϕ, n, m, offset, bar_r, tw, ndiv1, ndiv2) =
    generic_vert_truss(trig_truss, false,
        p, r, r_amp, h, ωh, ωϕ, n, m, bar_r, tw,
        find_divisible_num(find_divisible_num(n, ndiv1), ndiv2),
        # n subdivision to 1/10 or more
        offset)

# ╔═╡ e146c486-5849-4362-a9b1-e02dab7d57f0
run_test(trig_truss_test) do
    delete_all_shapes()
    line.(map_division(x, 0, 30, 10), map_division(i -> xy(i, -i / 3), 0, 30, 10))
    trig_truss(map_division(x, 0, 30, 10),
        map_division(i -> xy(i, i / 3), 0, 30, 10), 0.1)
    trig_truss(map_division(x, 0, 30, 10),
        map_division(i -> xy(i, -i / 3), 0, 30, 10), 0.1)
end

# ╔═╡ 3be14272-fd8b-466b-8c0a-d07024ceeab9
md" ▶ Generate triangular truss $(@bind l_trig_truss_test CheckBox(default=false))"

# ╔═╡ 1912596b-bfb2-4a3c-aea2-029516593f06
run_test(l_trig_truss_test) do
    delete_all_shapes()
    trig_truss(u0(), 20, 5, 10, 1, 2, 100, 10, 2, 0.05, 1, 50, 5)
    trig_truss(x(80), 20, 5, 10, 1, 4, 60, 10, 2, 0.05, 1, 50, 5)
    trig_truss(x(160), 20, 5, 10, 1, 8, 80, 6, 2, 0.05, 1, 50, 5)
end

# ╔═╡ 7369b33e-fcbb-429c-a4ad-1b25c71f6044
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/trig_truss.png") |> load

# ╔═╡ 7a6c4967-4acb-4026-bbca-abfa079cf829
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/trig_truss_vars.png") |> load

# ╔═╡ 54f6b25a-f8bf-407f-9b2c-b2484bdf312f
facade_truss(p, r, r_amp, h, ωh, ωϕ, nb, mb, offset, bar_r, tw, ndiv) =
    begin
        horizontal_truss(p, r, r_amp, h, ωh, ωϕ, nb, mb, bar_r, tw)
        vertical_truss(p, r, r_amp, h, ωh, ωϕ, nb, mb, bar_r, tw, ndiv)
        trig_truss(p, r - tw, r_amp, h, ωh, ωϕ, nb, mb, offset, bar_r, tw,
            ndiv, find_divisible_num(ndiv, 5))
    end

# ╔═╡ cf784819-0630-4331-b727-9b4fb959f6f7
md" ▶ Generate façade truss $(@bind facade_truss_test CheckBox(default=false))"

# ╔═╡ ea109f29-2d1a-47a9-af04-1fafd156eaaf
run_test(facade_truss_test) do
    delete_all_shapes()
    facade_truss(u0(), 20, 5, 10, 1, 2, 100, 10, 2, 0.05, 1, 50)
    facade_truss(x(80), 20, 5, 10, 1, 4, 60, 10, 2, 0.05, 1, 50)
    facade_truss(x(160), 20, 5, 10, 1, 8, 80, 6, 2, 0.05, 1, 50)
end

# ╔═╡ 2428dd13-08bf-4110-9030-48a67da0198d
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/truss_ver_hor.png") |> load

# ╔═╡ a349ac42-2420-4782-9ebb-1447da8103c5
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/facade_truss_vars.png") |> load

# ╔═╡ a4bdc1f6-bea0-4d92-b5fa-aef2ee1527f6
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/facade_truss_vars_.png") |> load

# ╔═╡ a0a5a31d-0609-432e-ab48-e4868ed008ee
md"#### Modify roof array order"

# ╔═╡ d9c64986-a58b-4f78-96e6-52b68b9884c0
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/roof_matrix1.png") |> load

# ╔═╡ 829b3c32-ebab-4050-a65b-8868d46a9a3d
md" ▶ Generate original matrix $(@bind original_matrix_test CheckBox(default=false))"

# ╔═╡ 8c65bd6f-e5a7-4a90-a885-5bdc9f362c3c
run_test(original_matrix_test) do
    delete_all_shapes()
    # matrix points
    map(ps -> sphere.(ps, 0.1), roof_pts(z(10), 5, 20, 5, 10, 1, 1, 20, 10))
    # original concentric lines
    map(spline, roof_pts(z(10), 5, 20, 5, 10, 1, 1, 20, 10))
end

# ╔═╡ 42025733-5767-4731-82ac-7d3f630d577e
md" ▶ Generate transposed matrix: with tilted lines $(@bind tilted_lines_test CheckBox(default=false))"

# ╔═╡ b836df7d-986b-47ff-a3ce-ec7756b447f1
run_test(tilted_lines_test) do
    delete_all_shapes()
    # lines tilting forward
    map(spline, transpose_matrix(roof_pts(z(10), 5, 20, 5, 10, 1, 1, 20, 10)))
    # lines tilting backward
    map(spline, transpose_matrix(
        rotate_matrix(roof_pts(z(10), 5, 20, 5, 10, 1, 1, 20, 10), false)))
end

# ╔═╡ fe5e6756-c9ee-4b90-89a0-0b3a225ca564
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/roof_test2.png") |> load

# ╔═╡ 28afaa7e-2872-41e7-838a-6a7a12649011
md" ▶ Generate rotated+tilted points to match diamonds $(@bind rotated_tilted_test CheckBox(default=false))"

# ╔═╡ 4c6c80ba-dd8a-4fdc-8628-83e5e42da94d
run_test(rotated_tilted_test) do
    delete_all_shapes()
    # rotated tilt
    map(spline, rotate_matrix(transpose_matrix(
            roof_pts(z(10), 5, 20, 5, 10, 1, 1, 20, 10)), false))
    # rotated tilt
    map(spline, transpose_matrix(rotate_matrix(transpose_matrix(
            roof_pts(z(10), 5, 20, 5, 10, 1, 1, 20, 10)), false)))
end

# ╔═╡ d73af2f1-0cf0-40f7-be81-05fa181e6aef
md"Problem: where does the matrix end now?"

# ╔═╡ 70be4467-1d05-4ca7-86ed-c682e286dd17
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/roof_test3.png") |> load

# ╔═╡ 81e36320-015e-4a66-aba1-93bbbdcd09d0
md" ▶ Generate matrix prepared for iterate diamonds $(@bind iterate_matrix_test CheckBox(default=false))"

# ╔═╡ 03509878-4ed5-4bd7-b45d-926edb06ac93
run_test(iterate_matrix_test) do
    delete_all_shapes()
    # zig-zag lines
    map(line, transpose_matrix(custom_rotate_matrix(
        roof_pts(z(10), 5, 20, 5, 10, 1, 1, 20, 10), 0, false)))
    # zig-zag lines
    map(line, custom_rotate_matrix(
        roof_pts(z(10), 5, 20, 5, 10, 1, 1, 20, 10), 0, false))
end

# ╔═╡ 5a1b3462-828d-445b-88bc-c7ff8cef6b83
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/roof_test4.png") |> load

# ╔═╡ c4775141-9fd6-43e1-aa24-d6e07c581d8a
""" Rotate roof rearranges the matrix of points so as to provide the iterate functions groups of 3 or 4 points in the expected order. """
rotate_roof(ptss) =
    let ptss = custom_rotate_matrix(ptss, 0, false)
        # bring all arrays back to ϕ=0 in zig zag
        ptss = transpose_matrix(ptss)
        # transpose to get first rows by angle (not radius)
        ptss = vcat([ptss[end]], ptss)
        # repeat last row to connect the circular arrays
        transpose_matrix(ptss)
        # transpose back to a row-by-radius organization
    end

# ╔═╡ 23cd24c5-349f-4413-80c8-c381303f49e6
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/roof_matrix2.png") |> load

# ╔═╡ 2202ff78-13a4-4c3a-a954-29877dc9ae38
md"#### Map geometry onto roof"

# ╔═╡ e52f8a7c-e0d2-4720-ab9e-afe0bdb321f9
md" **Parameters**
* p = bowl center at the base
* r min = roof whole radius
* r = bowl radius
* r amp = bowl curvature amplitude
* h = bowl height
* ωh = frequency in height
* ωϕ = frequency around the bowl (from 0 to 2π)
* nr = nr points around the roof (from 0 to 2π)
* mr = mr points along the radius on the roof
* offset = width of the roof surface (bubbles use the remaining radius)
* rt = roof surface thickness
"

# ╔═╡ 41c4a7ba-1d08-4c5e-99d3-b1998654a484
roof_bubbles(p, r_min, r, r_amp, h, ωh, ωϕ, nr, mr) =
    let ptss = roof_pts(p, r_min, r, r_amp, h, ωh, ωϕ, nr, mr)
        ptss_1 = rotate_roof(ptss)
        # first set of bubbles (Black Checkerboard)
        iterate_diamonds(bubble, ptss_1)
        # remove first row to make the second Checkerboard
        ptss_2 = ptss[2:end]
        ptss_2 = rotate_roof(ptss_2)
        # second set of bubbles (White Checkerboard)
        iterate_diamonds(bubble, ptss_2)
        (as, bs) = (ptss_1[1:2])
        (xs, zs) = (ptss_1[end-1:end])
        # first row -> triangular bubbles
        iterate_triamonds(tri_blubble, as, rotate_array(bs, 1))
        # last row -> triangular bubbles
        iterate_triamonds(tri_blubble, zs, rotate_array(xs, 1), -)
    end

# ╔═╡ 4719c2c8-ef9b-4ce3-85ae-a4137025e417
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/chequerboard.png") |> load

# ╔═╡ 90ce8f3b-739c-4d18-9bce-4d98d020c71e
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/roof_bubbles.png") |> load

# ╔═╡ c929b47a-85ec-4af8-a22c-ef9f8c941c0e
md" ▶ Generate roof bubbles $(@bind roof_bubbles_test CheckBox(default=false))"

# ╔═╡ a382746c-3e19-4931-abb0-a42ccf66199a
run_test(roof_bubbles_test) do
    delete_all_shapes()
    roof_bubbles(z(10), 5, 20, 5, 10, 1, 1, 20, 10)
    roof_bubbles(z(30), 5, 20, 5, 10, 1, 1, 20, 11)
end

# ╔═╡ 5d263939-8529-41fd-bc93-e27db655d927
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/roof_bubbles2.png") |> load

# ╔═╡ ea1d6d81-8734-4349-8f15-a2d0c6cf3c1e
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/roof_diamind_numbers.png") |> load

# ╔═╡ 5cb65686-a8af-4d0d-8987-9563169d6f22
roof_surf(p, r_min, r, r_amp, h, ωh, ωϕ, n, mr, offset, rt) =
    let ptss(rad) = roof_pts(p, r_min, rad, r_amp, h, ωh, ωϕ, n, mr)[end]
        ptss1, ptss2 = ptss(r), ptss(r - offset)
        thicken(surface_grid([ptss1, ptss2], false, true), rt)
    end

# ╔═╡ 27d21c5e-5afc-41f0-b6dc-d59e7ba52640
md" ▶ Generate roof surface $(@bind roof_surf_test CheckBox(default=false))"

# ╔═╡ b24f35b4-ec41-4591-86a3-dca18076f9c5
run_test(roof_surf_test) do
    delete_all_shapes()
    roof_surf(z(10), 5, 20, 5, 10, 1, 2, 20, 10, 2, 0.3)
    roof_surf(z(30), 5, 20, 5, 10, 1, 2, 35, 10, 2, 0.3)
end

# ╔═╡ b13e1b5b-a356-4b10-ad0a-0d2160ac6347
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/roof_surf.png") |> load

# ╔═╡ b8e2e3b5-6aee-4e0d-93ef-fbb7a3723390
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/roof_surf_vars.png") |> load

# ╔═╡ 237c1840-615b-4764-8b3f-8692f5471f60
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/roof_and_bars.png") |> load

# ╔═╡ fdf0bbf2-3ac7-42b9-81ac-f337acfa41c6
roof_truss(p, r, r_amp, h, ωh, ωϕ, nb, mb, offset, bar_r) =
    let m1 = round(Int, mb / find_divisible_num(mb + 1, 3))
        ptss_down(rad, i) = bowl_pts(p, rad, r_amp, h, ωh, ωϕ, nb, m1)[i]
        as, aas = ptss_down(r - offset, m1), ptss_down(r, m1)
        bs, bbs = ptss_down(r - offset, m1 + 1), ptss_down(r, m1 + 1)
        space_truss(as, aas, bs, bbs, bar_r)
    end

# ╔═╡ c63e2b9f-4ec9-468a-821a-22323924f683
md" ▶ Generate roof truss $(@bind roof_truss_test CheckBox(default=false))"

# ╔═╡ afc6bb3e-fae9-4d7f-99a5-f4d51ec2912b
run_test(roof_truss_test) do
    delete_all_shapes()
    roof_truss(u0(), 20, 5, 10, 1, 1, 100, 10, 2, 0.05)
    roof_truss(x(200), 20, 30, 30, 1 / 2, 8, 100, 6, 25, 0.05)
end

# ╔═╡ 4350794e-7ae4-4ae5-a0cb-8f1d3aeaf8bd
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/roof_truss.png") |> load

# ╔═╡ 82ca80f9-1fbe-41f2-bfe5-9f29df5ee6ce
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/truss_and_surf.png") |> load

# ╔═╡ 6eb75df2-afa7-490a-b659-992997fff79e
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/truss_spatial_lusail.png") |> load

# ╔═╡ 2afc3762-6968-4282-b0f6-93c5b41f5e01
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/truss_spatial_lusail2.png") |> load

# ╔═╡ 47473dd9-a17d-4ea8-84c5-5b83dd3cd093
md"### Base"

# ╔═╡ c0f0be86-1368-4c11-8b2b-83f52d2de26c
""" Typical football field measures: 90m x 120m. """
football_field(p, w, l, h) = box(p - vxy(w / 2, l / 2), w, l, h)

# ╔═╡ 26368893-3759-4a5d-825f-54698d7ded34
"""
### Parameters
p = center point \\
r = base radius \\
hf = height for the floor slab \\
ww = wall width \\
hw = wall height \\
nw = number of doors/ walls in between doors \\
dw = door width/span (dimension expected in radians)
"""
base(p, r, hf, ww, hw, nw, dw) =
    let profile = surface_polygon(p + vx(r), p + vx(r + ww), p + vxz(r + ww, hw), p + vxz(r, hw))
        wall_section(α, Δα) = revolve(profile, p, vz(1), α, Δα)
        cylinder(p, r, -hf)
        Δϕ = 2π / nw
        [wall_section(ϕ, Δϕ - dw) for ϕ in division(0, 2π, nw)]
    end

# ╔═╡ 5dc0939e-9df7-4aed-870a-53c1f84c2c07
md" ▶ Generate base $(@bind base_test CheckBox(default=false))"

# ╔═╡ b852401f-b919-42c6-a3ea-bf8861b84633
run_test(base_test) do
    delete_all_shapes()
    base(u0(), 10, 0.1, 0.2, 2, 5, π / 10)
end

# ╔═╡ 3127486a-f4c9-41bc-a42e-12cdd3c7d24d
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/base.png") |> load

# ╔═╡ 57956a81-c59d-4aea-9996-44c9848737a5
md"### Bleachers"

# ╔═╡ 3d1ab831-cce8-4f23-b855-6c9cf3dfa73b
md"
#### Superellipse

$x(t) = a \cdot (\cos^2t)^\frac{1}{n} \cdot sgn(\cos t)$
$y(t) = b \cdot (\sin^2t)^\frac{1}{n} \cdot sgn(\sin t)$
$-\pi < t < \pi$

* p = center point
* a = radius on the $X$ axis
* b = radius on the $Y$ axis
* n = curvature($n<1 \rightarrow$ star, $n=1 \rightarrow$ diamond, $n=2 \rightarrow$ eclipse, $n>2 \rightarrow$ square)
* t = time (value from $-\pi$ to $\pi$)
"

# ╔═╡ b1049b3b-cbfd-4a59-9fe5-38fe0d1d267d
superellipse_x(a, b, n, t) = a * (cos(t)^2)^(1 / n) * sign(cos(t))

# ╔═╡ f8d8e0f7-dfd7-47fa-bccd-51f18196f37d
superellipse_y(a, b, n, t) = b * (sin(t)^2)^(1 / n) * sign(sin(t))

# ╔═╡ ca1645e9-73b2-4ff3-a6bc-689109534143
md" **Interactive test**

* a = $(@bind a Slider(1:20;show_value=true))
* b = $(@bind b Slider(1:20;show_value=true))
* n = $(@bind n Slider(0.1:.01:6;show_value=true))
"

# ╔═╡ 15dc95fb-0b4b-47a8-be1d-2004517632f9
let t = range(0, 2π, length=80)
    x = superellipse_x.(a, b, n, t)
    y = superellipse_y.(a, b, n, t)
    plot(x, y, title="Superellipse", label="Superellipse", linewidth=2)
end

# ╔═╡ 33a3fdc6-501c-4d68-b03e-1ac5b0a2266d
superellipse(p, a, b, n, t) =
    p + vxy(a * (cos(t)^2)^(1 / n) * sign(cos(t)),
        b * (sin(t)^2)^(1 / n) * sign(sin(t)))

# ╔═╡ 98e1e750-18fc-4ca7-b59d-cce73640e5ea
"""
### Parameters
n = superellipse's curvature (n<1: star, n=1: diamond, n=2: ellipse, n>2: square) \\
pts = number of points in each superellipse curve
"""
superellipse_points(p, a, b, n, pts) =
    [superellipse(p, a, b, n, t) for t in division(-π, π, pts, false)]

# ╔═╡ b7d302af-0316-4601-bde8-b992008c9c38
md" ▶ Generate superellipse $(@bind superellipse_test CheckBox(default=false))"

# ╔═╡ 4d280ca2-0b96-4ddf-a647-8dcd7be467e7
run_test(superellipse_test) do
    delete_all_shapes()
    spline(superellipse_points(u0(), 5, 7, 5, 100))
end

# ╔═╡ 4aa82ae6-b14d-41bb-8c6a-59ca8a4e4554
stair_superellipse(p, a, b, n, pts, d, n_str) =
    vcat([[superellipse_points(p + vz(d * i), a + d * i, b + d * i, n, pts),
        superellipse_points(p + vz(d * (i + 1)), a + d * i, b + d * i, n, pts)]
          for i in 0:n_str-1]...)

# ╔═╡ b7740b44-c211-45a1-97fa-a636a40e74ea
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/bleachers.png") |> load

# ╔═╡ 19859f6a-534e-43f1-9b0d-538c096c5895
md" ▶ Generate superellipse staircase $(@bind superellipse_stair_test CheckBox(default=false))"

# ╔═╡ 2b61d937-6f3f-41e4-9a68-e93d1785fbdf
run_test(superellipse_stair_test) do
    delete_all_shapes()
    stair_superellipse(u0(), 5, 7, 5, 100, 0.6, 10)
    map(spline, stair_superellipse(u0(), 10, 15, 5, 100, 0.6, 10))
    surface_grid(stair_superellipse(u0(), 10, 15, 5, 100, 0.6, 10),
        false, true, false, false)
end

# ╔═╡ a9c9e5c7-d931-42a7-9e01-ac72e56f41b4
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bleacher_set.png") |> load

# ╔═╡ 03b1d04a-74ed-4553-afdd-075f6e484fb8
"""
### Parameters
d = step size (.6 is a nice value for a chair-size step) \\
n str = number of steps in each staircase/bleacher section \\
n set = number of bleacher sections (in height)
"""
bleachers_mtx(p, a, b, n, pts, d, n_str, n_sets) =
    let set_d = d * n_str
        corridor = 3d
        vcat([stair_superellipse(p + vz(set_d * i),
            a + set_d * i + corridor * i,
            b + set_d * i + corridor * i,
            j, pts, d, n_str)
              for (i, j) in zip(0:n_sets-1, division(n, n - 3.5, n_sets))]...)
    end

# ╔═╡ 8cd50a46-25b4-4d95-bea4-3f76de93140d
md" ▶ Generate bleachers' matrix $(@bind bleachers_mtx_test CheckBox(default=false))"

# ╔═╡ 7b5ee0ca-7add-4148-9ae4-f596a4103dea
run_test(bleachers_mtx_test) do
    delete_all_shapes()
    bleachers_mtx(u0(), 5, 7, 5, 100, 0.6, 10, 3)
    map(spline, bleachers_mtx(u0(), 10, 15, 5, 100, 0.6, 10, 3))
    #football_field(u0(), 10*2-4, 15*2-4, .1)
    #surface_grid(bleachers_mtx(u0(), 10, 15, 5, 100, .6, 10, 3), false, true, false)
end

# ╔═╡ b0393d09-cc82-4993-8afb-e8f491de6315
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bleach_splines_2.png") |> load

# ╔═╡ 645eef54-d10f-4643-a67b-b0fdd6c9a9ad
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/bleachers_surf.jpg") |> load

# ╔═╡ cf06164f-2eda-4de2-8c6e-da92c53eb642
bleachers(p, a, b, n, pts, d, n_str, n_sets) =
    try
        surface_grid(bleachers_mtx(p, a, b, n, pts, d, n_str, n_sets),
            false, true, false)
    catch e
        if isa(e, KhepriBase.BackendError)
            println("Surface grid self-intersection.
   One or more bleach sets were not drawn near the end.")
        end
        println(e)
    end

# ╔═╡ 8c72ce13-a9bd-4f00-b88a-d930709852cc
md" ▶ Generate bleachers $(@bind bleachers_test CheckBox(default=false))"

# ╔═╡ e4e24951-3d16-49fb-94a0-66737e7e6c9a
run_test(bleachers_test) do
    delete_all_shapes()
    bleachers(u0(), 10, 15, 5, 50, 0.6, 10, 3)
end

# ╔═╡ 3df8d99b-e5d8-46fa-a7f1-eeecf182c001
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/base_bleachers.png") |> load

# ╔═╡ 9305650a-1c19-4f18-9eb7-2859ec8a8dd3
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bleachers_roof_truss.png") |> load

# ╔═╡ 91f1dfe4-8f8f-42f4-8fdf-8c30dfd1baa2
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bleach_var1.png") |> load

# ╔═╡ 3d760d90-72b3-4ddf-b496-b763ab488ad5
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/bleach_var2.png") |> load

# ╔═╡ 8865b9c2-c4f1-4dea-a6f0-c8fe6e6f3dee
md"## **Complete Stadium**"

# ╔═╡ dca999da-ada3-4f63-a308-c6b38b5a1ca3
md"
### Parameters

* p = bowl center at the base
* r min = roof whole radius
* r = bowl radius
* r amp = bowl curvature amplitude
* h = bowl height
* ωh = frequency in height
* ωϕ = frequency around the bowl (from 0 to 2π)
* mb = m points in height on the bowl
* mr = mr points along the radius on the roof
* bd = bleacher bench/step size
* n str = number of steps in each bleacher section
"

# ╔═╡ c52734da-cd52-4f8f-955f-06e117a4727b
md"
### Fixed Local Variables
(calculated to match)

* mb = if the value provided for mb is lower than 6, mb shall be 6
* nb = n points around the bowl (from 0 to 2π)
  + l = triangle side and height
  + l = h/mb $\Rightarrow$ l = 2πr/nb $\Rightarrow$ nb = 2πr.mb/h
* nr = nr points around the roof (from 0 to 2π)
  + l = diamond width and length
  + l = r/mr $\Rightarrow$ l = 2πr/nr $\Rightarrow$ nr = 2πr.mr/r
* ndiv = number of inner vertical truss columns (a number by which nb is divisible in order to match the pattern)
* r end = last bowl radius
* bleacher l = bleacher max length: distance between initial bleacher radius and last bowl radius
* n sets = number of sets (bleacher sections) that fit within the bleacher length or height (whichever yields the minimum limit)
"

# ╔═╡ 5ad02271-131a-49fd-9d52-39bc3bbfedcb
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/calculate_nb.png") |> load

# ╔═╡ 407d4062-fc15-4e64-99b7-60e831aae9c2
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/facade_trig_number_side.png") |> load

# ╔═╡ 9746dbf2-b097-46e4-849e-7aa2a0c455c8
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/screenshots/facade_trig_numbers_top.png") |> load

# ╔═╡ 03ccbc29-d9c4-41e8-a00e-dc5e2019aca1
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/sketches/calculate_nr.png") |> load

# ╔═╡ 7e311587-d1f7-4187-a058-459d038373d5
md"
### Changeable Local Variables
(up for change, but tread carefully. not as safe as the function parameters)

* tw = inner bowl vertical/horizontal truss width (distance from the façade)
* offset = width of the roof surface and space truss $\Rightarrow$ currently 20% of the bowl radius (the remaining distance is used for the bubble matrix)
* bar r = truss bar radius
* surf t = roof surface thickness
* fw, fl, fh = football field width, length, and height
* hw = base wall height
* nw = number of entrance doors
* hf = base floor height
"

# ╔═╡ 94e869eb-31b2-4a7d-be18-1554f0a0e124
md"### Create Layers"

# ╔═╡ 999fe0b9-db6c-43c0-aca7-e4b9f2f0f3a2
md" ▶ Create Layers in AutoCAD $(@bind cl CheckBox(default=false))
Required to run the full stadium function."

# ╔═╡ fa03a2f5-b409-4bd4-9218-035b09d75eb6
run_test(cl) do
    global concrete = create_layer("concrete")
    global grass = create_layer("grass")
    global truss = create_layer("truss")
    global f_bars = create_layer("f_bars")
    global panels = create_layer("panels")
    global surf = create_layer("surf")
    global bubbles = create_layer("bubbles")
    global ground = create_layer("ground")
end

# ╔═╡ 5f78d45b-e363-48e6-a18e-32d32dcb83fd
"""
# Lusail Stadium
Note: most measures are shrunk for model performance
"""
lusail(p, r_min, r, r_amp, h, ωh, ωϕ, mb, mr, bd, n_str) =
    let mb = mb < 6 ? 6 : mb # minimum m value (6) for a proper truss
        # make nb depend on mb for (somewhat) equilateral triangles
        nb = round(2π * r * mb / h)
        # make nr depend on mr for (somewhat) balanced diamonds
        nr = round(π * r * mr / r)
        ndiv = find_divisible_num(nb, 50)
        # variables up for change:
        tw, offset, bar_r, surf_t = 1, 0.2r, 0.05, 0.3
        fw, fl, fh, hw, nw, hf = 13, 18, 0.02, 1, 5, 0.05
        # end of changeable variables
        r_end = r + sinusoid(r_amp, ωh * 0.7π / h, 0, h)
        bleacher_l = r_end - fl + 1
        n_sets = ceil(Int, min(bleacher_l / bd / n_str, (h - 0.2h) / bd / n_str))

        with(current_layer, panels) do
            @time facade_panels(p, r, r_amp, h, ωh, ωϕ, nb, mb)
        end
        with(current_layer, f_bars) do
            @time facade_bars(p, r, r_amp, h, ωh, ωϕ, nb, mb, 0.1)
        end
        with(current_layer, truss) do
            @time facade_truss(p, r, r_amp, h, ωh, ωϕ, nb, mb, offset, bar_r, tw, ndiv)
            @time roof_truss(p, r, r_amp, h, ωh, ωϕ, nb, mb, offset, bar_r)
        end
        with(current_layer, bubbles) do
            @time roof_bubbles(p + vz(h), r_min, r - offset, r_amp, h, ωh, ωϕ, nr, mr)
        end
        with(current_layer, surf) do
            @time roof_surf(p + vz(h + bar_r / 2 + surf_t / 2),
                r_min, r, r_amp, h, ωh, ωϕ, nr, mr, offset, surf_t)
        end
        with(current_layer, concrete) do
            @time bleachers(p - vz(hw), 0.6fw, 0.6fl, 5, 50, bd, n_str, n_sets)
            @time base(p - vz(hw), r, hf, 2bar_r, hw, nw, π / 10)
        end
        with(current_layer, grass) do
            @time football_field(p - vz(hw), fw, fl, fh)
        end
        with(current_layer, ground) do
            @time surface_circle(p - vz(hw - hf), 10r)
        end

    end

# ╔═╡ 0ab18e0c-53dc-4b52-b454-ce3050c6ec10
md"### Generate variations"

# ╔═╡ a1def259-1884-4f89-911e-84a09775da5f
md" ▶ Generate variation 1 $(@bind var1_test CheckBox(default=false))"

# ╔═╡ 0b85d252-39fe-45dc-a030-214960be4222
run_test(var1_test) do
    delete_all_shapes()
    lusail(u0(), 5, 20, 5, 12, 1, 2, 10, 10, 0.5, 6)
end

# ╔═╡ f44536c9-ec2c-4157-97be-b4b100a6ebf5
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/renders/Lusail_Stadium-frame-001.png") |> load

# ╔═╡ 6f46c577-0cfd-4819-a319-7307570e10e8
md" ▶ Generate variation 2 $(@bind var2_test CheckBox(default=false))"

# ╔═╡ 3b364fe7-0a4a-460b-98c1-562692c2942d
run_test(var2_test) do
    delete_all_shapes()
    lusail(u0(), 5, 40, 5, 20, 2, 4, 5, 14, 0.5, 6)
end

# ╔═╡ 5d577361-ded4-497c-b8e0-e9cdf36e41cb
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/renders/Lusail_2-frame-001.png") |> load

# ╔═╡ b7e98a7a-be01-48be-9412-55f27cb9dbfe
md" ▶ Generate variation 3 $(@bind var3_test CheckBox(default=false))"

# ╔═╡ 32fdd686-8919-4a82-acfb-58bd7ccbdce2
run_test(var3_test) do
    delete_all_shapes()
    lusail(u0(), 10, 20, 30, 30, 1 / 2, 8, 20, 20, 0.5, 20)
end

# ╔═╡ fa477807-1aa4-4684-929c-cc71c0558380
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/renders/Lusail_3-frame-000.png") |> load

# ╔═╡ 874ac0c3-1230-413f-bf35-09c99f558c58
md"### Saved Views"

# ╔═╡ c897a0d7-ae08-4de4-9fd2-c6f055a00c28
md"#### Aerials"

# ╔═╡ a1cb63a8-cfe8-468a-9d9a-dfefe017f857
md" ▶ Go to Aerial View $(@bind aerial_1 CheckBox(default=false))"

# ╔═╡ 7d136d97-6a6e-40d6-8944-434f3b225e85
run_test(aerial_1) do
    set_view(xyz(-94, -94, 101), xyz(0, 0, 7), 50)
end

# ╔═╡ 3af702f0-875e-46df-97c4-e0654c542669
md" ▶ Go to Aerial View $(@bind aerial_2 CheckBox(default=false))"

# ╔═╡ 781be443-d4b0-48fa-b073-5549510a9dc3
run_test(aerial_2) do
    set_view(xyz(0, -115, 122), xyz(0, 0, 7), 50)
end

# ╔═╡ 0687506b-b8d3-4432-bb0f-c6e59381f180
md" ▶ Go to Aerial View $(@bind aerial_3 CheckBox(default=false))"

# ╔═╡ 40af53c9-f4fc-480d-8a6e-7508efa19dba
run_test(aerial_3) do
    set_view(xyz(94, -94, 101), xyz(0, 0, 7), 50)
end

# ╔═╡ 887f528c-f22c-48de-a741-fb82b8891570
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/renders/aerials.png") |> load

# ╔═╡ 81a1029a-ee2c-4420-ba98-156b8a1b7df0
md" ▶ Go to Top View $(@bind top_view CheckBox(default=false))"

# ╔═╡ 366c198c-277e-4848-8028-b46d4a99a011
run_test(top_view) do
    set_view(xyz(0, 0, 170), xyz(0, 0, 7), 50)
end

# ╔═╡ 4c1a7612-035e-46b1-baea-02fc7acb578a
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/renders/Lusail_2-frame-002.png") |> load

# ╔═╡ c83a85a4-59e8-4b1a-b9e1-fc396f51d2df
md" ▶ Go to On the roof View $(@bind on_the_roof CheckBox(default=false))"

# ╔═╡ a22f98ad-2e70-4445-9101-533ae50c3ade
run_test(on_the_roof) do
    set_view(xyz(-29, 20, 23), xyz(15, -10, 2), 60)
end

# ╔═╡ 5562d28e-b991-42ad-8d2a-9119d3e08361
md"#### Sides"

# ╔═╡ d0e5e8ea-88a5-4e28-8edc-1ac862490e34
md" ▶ Go to Side View $(@bind side_1 CheckBox(default=false))"

# ╔═╡ fca358b5-de42-434a-a5c1-0d2ef7d01f15
run_test(side_1) do
    set_view(xyz(0, -163, 7), xyz(0, 0, 7), 50)
end

# ╔═╡ 5fbbadad-5420-481c-867b-9a3cd976d928
md" ▶ Go to Side View $(@bind side_2 CheckBox(default=false))"

# ╔═╡ 95a12a45-01d9-4116-940c-ccbb4e7c5136
run_test(side_2) do
    set_view(xyz(115, -115, 7), xyz(0, 0, 7), 50)
end

# ╔═╡ 0ca8aecb-4e4c-4b8d-86f4-8f508683f462
md" ▶ Go to Side View $(@bind side_3 CheckBox(default=false))"

# ╔═╡ 6588604b-8271-47b4-98d2-112f7c73a39a
run_test(side_3) do
    set_view(xyz(115, 115, 7), xyz(0, 0, 7), 50)
end

# ╔═╡ b959cc7f-58f6-4f68-8bfb-c93b0bdcc798
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/renders/sides.png") |> load

# ╔═╡ 9a81ac7f-eccf-4344-a006-5800132facc9
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/renders/Lusail_2-frame-004.png") |> load

# ╔═╡ f742793f-e965-453c-8912-4feb5ffdf387
md"#### Human scale"

# ╔═╡ d39ab0ee-8efa-417b-8756-79d3dbe0d81b
md" ▶ Go to Ground View $(@bind ground_1 CheckBox(default=false))"

# ╔═╡ 6ab8efde-7923-430e-9821-2f42c8e60c1b
run_test(ground_1) do
    set_view(xyz(1, -95, 0), xyz(0, 33, 8), 50)
end

# ╔═╡ 100ee448-ee6f-4cff-93cb-daed4716907e
md" ▶ Go to Ground View $(@bind ground_2 CheckBox(default=false))"

# ╔═╡ 87ccd5d9-9650-4e0f-afe4-c4b2fa259f6d
run_test(ground_2) do
    set_view(xyz(72, -60, 0), xyz(-25, 21, 7), 50)
end

# ╔═╡ dbcf460c-4f91-4a53-895a-e5f3ad723e33
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/renders/grounds.png") |> load

# ╔═╡ 8a9844b2-a23e-4414-a647-bfe38dfbdf7f
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/renders/Lusail_3-frame-001.png") |> load

# ╔═╡ 4ed8a76d-44b2-4893-b923-60c9117b8488
md" ▶ Go to Inside View $(@bind inside_view CheckBox(default=false))"

# ╔═╡ 6cf110d0-05ae-4615-a9bf-673df472772b
run_test(inside_view) do
    set_view(xyz(-8, 5, 0), xyz(35, -5, 21), 18)
end

# ╔═╡ ac726940-3990-466d-989a-f5875081b438
download("https://web.ist.utl.pt/renata.castelo.branco/Lusail_resources/renders/Lusail_2-frame-007.png") |> load

# ╔═╡ 9ba32774-a4b1-41b1-bbd2-538684e7a11e
md"### Render"

# ╔═╡ 96c27d74-03c4-42f6-be0f-a78003cf0b27
render_quality(-0.5)

# ╔═╡ 37417c86-cf2f-438e-8dab-2f8be3b7c74d
render_exposure(0.6)

# ╔═╡ 7b79d383-de1e-4790-af17-6843a21e11fa
render_size(1920, 1080)

# ╔═╡ a9eeac32-cda5-4d9c-a41c-ad7bcdda53aa
start_film("Lusail_Stadium")

# ╔═╡ e6334309-ed59-4035-927f-efccbde55c1d
md" ▶ Render image $(@bind render_img CheckBox(default=false))"

# ╔═╡ 9844167d-11cf-4b8f-b8a3-a4fc9c7edac2
run_test(render_img) do
    save_film_frame()
end

# ╔═╡ 2479956b-b158-4205-8fa4-a25a305d04a6
md"For more on **algorithmic design** and **parametric 3D geometry modeling** visit: _https://algorithmicdesign.github.io_"

# ╔═╡ Cell order:
# ╟─5945f0a5-066d-4d28-93d2-926b6e3b014b
# ╟─336fe6af-7ea8-44b2-add3-d45733eff681
# ╟─9a62eced-0aed-4ad5-9931-f5873d9d542c
# ╟─80b3e1db-a2f3-4336-a4de-685122de4c99
# ╟─b5c47c9f-408c-41a0-b389-87eabd45c52c
# ╠═6931af5b-70ce-499e-ab87-106e9583f1b3
# ╠═f6595c53-4db5-4ba8-9d20-d6b0214475f3
# ╠═ef9d3d71-3129-4479-bdd6-f750e7ce14b4
# ╠═9ea9a5a2-9951-429f-a772-5021b1714386
# ╠═2a7d6543-38c8-4a83-a940-2455eba324ac
# ╠═a3ec0de8-2a18-4ddb-a7cf-d8b14fd2027f
# ╟─73f2da10-c2c7-45e4-a9a5-5138ff4590e3
# ╠═44b45f73-95d9-449a-abb6-9f4d92538cd3
# ╠═33dfede5-1c9a-4156-b1dd-82bf1531df89
# ╟─c7a0d341-8aa3-4af6-a585-c86d7d42eaf2
# ╟─f6385204-4170-4deb-94c4-1e1b90b2666d
# ╠═17b1711b-6546-463a-ba49-e44df454ba78
# ╟─a7b9c225-90c7-4760-b0f2-4e11d059eb86
# ╠═7e4d3e68-99bf-424f-892f-dffe10d781f1
# ╟─0ccf218f-f381-4d8d-8005-352faf1fb030
# ╟─f2dde536-335b-46e2-9fa1-62f62ef91791
# ╟─160cbe02-943d-4091-a003-f6199b1c260b
# ╠═5f4c1d1b-ac76-4f0a-ba05-d1f556c6a578
# ╟─ed37e6c2-24d6-4a30-b08c-74024fadbc89
# ╠═b550b52c-1186-4e51-82fb-08101a5cc541
# ╟─25a28cb0-e507-430f-ba7a-d633d12ee50b
# ╠═7b9b03f0-0ba1-40b8-b24e-9b848b15b6b7
# ╟─8cef0e25-55ea-46eb-b983-01c0d7455432
# ╠═2fbf81d4-a312-4f84-aad3-0d55c90240a4
# ╟─28bb90d6-4480-4c4c-9b9b-a8c17adefdb2
# ╠═ba2d310c-7507-4dee-a0db-35a54b6410bd
# ╟─6a69e887-dc18-4ce2-a6d7-afdd2112470c
# ╟─9b00f0a1-ec90-4d18-93b0-c08e7ef16f8a
# ╠═d85bd24b-5658-4319-8a82-6ba02408aa33
# ╟─e4fa867a-19be-4c2b-a0bc-1cdeaae010a6
# ╟─634e6b43-be34-46d0-8dc1-e06adfcbf658
# ╟─2c81c635-df9c-49c4-bcac-dbfd24737261
# ╠═252e33f6-de0b-4c6c-8ee9-1859de068857
# ╟─a56aba0e-90dc-405b-907b-7a7e09dc1ec6
# ╠═631789f0-4dc0-4eb8-9dcd-a8ac32892b69
# ╟─e1cc3186-00e7-4560-9425-71241139c6c4
# ╟─c651d012-0eaa-4954-976b-b11b524a6bb4
# ╟─102de52c-b5b7-4953-99be-a97352b50731
# ╟─bb2bdb18-ca44-4d18-98e5-9708473ee046
# ╟─ac4d4c31-090b-44b3-8e7a-16da651c4d7e
# ╠═21e81955-0b0e-4e1f-adcf-db79a6749a08
# ╟─485101b9-5ddd-4092-8f0e-3ef4313846c5
# ╠═f21cd0a3-de3c-4aa8-be4b-f3ad4a94867f
# ╠═8215cb70-adc3-4a62-9797-a2a6a9462ea3
# ╟─1c0ce485-341c-4d84-b3ca-d68c10aa6202
# ╠═a8fb896e-e4bd-4643-bc26-b5d8c2548ee1
# ╟─6505c491-f53d-4c4c-977d-ae6565d60c5f
# ╟─7782525b-f6b5-4424-9995-3c91e9c59a06
# ╟─2564b841-1b1b-4fb3-ac21-6bfa55c6f39a
# ╟─d67f2ae3-f9c5-4c43-8fbd-441c04fdb8e6
# ╠═c137ef22-abfc-4ec5-a7f6-30f6da9d7e69
# ╟─efaffbf1-32ea-4528-a32f-ee71b95c7ee9
# ╟─9b0b8eac-890d-4890-aa7e-74cef3970211
# ╠═03795ef0-5b26-459e-a914-ded3d65d5376
# ╟─e33c78e8-4669-4d51-ac75-6d654ee50256
# ╟─29547eba-08f8-4d55-b5ad-ed9a144b6faf
# ╠═a63b26d0-b0ec-42b1-b5be-3e7eca7a242d
# ╟─36a6b9f6-dab0-4638-8969-c6bac473d520
# ╟─49314522-210d-40a8-a540-91c0754316bf
# ╠═c64f722b-8c41-485e-8526-f02b96bd24af
# ╟─587d8649-509f-4cbc-97d2-494b2016b193
# ╟─4dea6eb9-d9bf-4915-af1e-768827c44152
# ╟─e055f3c2-5f12-4735-93ee-57eb549b34b8
# ╟─8e4354c1-4c2a-4baf-b287-4c3650d2597d
# ╠═f53bb5e9-e82c-4076-9844-cb1a3a704329
# ╟─8c02a388-badf-4a61-9d56-98fb6f2ec88b
# ╠═d0a4c6d2-50f6-4dc0-bd04-07a185aed377
# ╟─9284c7ea-4a54-41c5-bdad-5fcc9656681b
# ╟─5536357c-c701-4f71-91d0-b5dc33e3fb8a
# ╠═dff6ad93-da7a-4df9-9590-18fe82355307
# ╟─30e4f849-306d-4d89-b727-dda507d8d93a
# ╠═a955e573-9244-48a2-bc37-e1f42625a9a5
# ╠═04e31783-6d73-4b0f-8eab-f6a05e0292a6
# ╟─1a09acf7-8f9f-4537-aae3-f2022eff0216
# ╠═43abb92f-cd29-404d-9058-61662a57d514
# ╠═9075bdd9-cc0d-4cba-adda-82ea9aee6ccf
# ╟─f8a7f4bc-c573-4ea7-88fa-52fa7cd34b8d
# ╠═864c50d9-28c3-4e2b-9cb1-21fb0dd175d0
# ╠═1b7c984a-3031-4a6f-8107-5a970aca14db
# ╠═b35bf970-9569-4ca6-bbb2-412bb9e2bac8
# ╠═838861a6-f323-4446-87d3-e2b5d78282f8
# ╠═36bdb831-86c0-4850-9f73-88cf5df90b24
# ╠═1b0f4013-665c-442c-a08d-5c5e140b2dee
# ╠═95fa774e-ee8b-48e1-bb60-553c71ee64b8
# ╠═58623144-6bc3-410f-80c5-2746ac081142
# ╠═4595e96b-78fb-4d6c-847d-95e61f3109f6
# ╠═2b2fd125-2dff-4c4d-a70e-54069630b104
# ╠═3f75fd90-f596-49e9-a279-802839b36318
# ╟─2a70c776-f438-406c-b8c6-2e8fca5c889f
# ╠═2f860d64-2d0d-4b30-bc15-33000fb27826
# ╟─97abe45e-e2db-4945-bf45-ece37d29a292
# ╟─fe7e4243-88d0-4aec-977c-e182134a4db9
# ╠═124916cb-1c1b-47bc-a84a-345ba089b898
# ╟─25de6753-a73e-4582-aaa7-857cbd4fbf2b
# ╠═ca1db2b7-3413-4d2f-a1a7-c9684d08af16
# ╟─33c592df-3a7d-408e-b9db-ae628630c7ef
# ╠═c5eabcfb-f3b6-49c1-bd40-860e6dea1b71
# ╟─278086e6-5dc5-49a0-ab94-3f8bca36aeeb
# ╠═56f12188-ed55-4a9a-94a9-f14d7f90f40e
# ╟─175814f6-359c-4dc2-9d6f-6d7125066b29
# ╠═76dde91a-9968-40f6-8fd7-75aa30067297
# ╠═a72bc18f-8eba-41b7-bfc2-4835c19e45f0
# ╠═4776df76-098b-4a02-b57f-5f1f5d3c247f
# ╠═48aa4507-8646-407e-9ec3-242e85e9b6a2
# ╟─931a160c-39f9-4f99-9e8a-f94f1c801361
# ╟─33f711c3-5626-4165-8a25-c921e12f34ef
# ╠═1a86d434-6353-432f-95d7-1c6ac472d3c6
# ╟─accf60b6-c3cd-4b8b-9dee-553410568c0b
# ╟─535bc44f-4d17-408e-8d81-4168a380157b
# ╠═2566bf52-5de9-4bb8-82f9-51bd1966650b
# ╟─222ef4ec-d907-4cc9-b463-5a5ca02bd91d
# ╟─ef1f1a40-e42d-43c6-bc93-37e8728c555a
# ╠═e146c486-5849-4362-a9b1-e02dab7d57f0
# ╟─eb2c0ba9-5efe-455a-8c95-eb1b81ed0885
# ╠═f9cf0031-2a9f-446e-8c80-705bf7d950a6
# ╟─3a9aafff-0ce6-484d-9d62-8ffb998dbc08
# ╟─fd44a40c-32e1-41c1-a2b0-87791dffa8d4
# ╠═8e4a0c60-4e15-433b-8f0d-95e890dea555
# ╟─ecb351b2-aff6-4bb3-a2d2-8c7b475128a5
# ╠═8d9b35f8-7e0e-43e4-8ead-742cf59e3cfd
# ╟─7c67815e-1a59-4a7a-82c9-2839bd85e6fa
# ╟─38dc97f3-5773-4735-806f-932158bd7c2f
# ╠═1d763f04-fc17-4c5e-8854-197bfdda918e
# ╟─f9508fb4-5703-4087-b2e4-6fed3d04c78a
# ╟─bb757825-1cf7-4ebe-af49-15e2a253c8f5
# ╟─4363d786-5594-41cc-bf9b-a577f7719d93
# ╠═efd74cc7-71b1-445b-91c5-e095e795ae9a
# ╟─1215da5d-9e4f-4b7e-9622-7a4526577ca1
# ╠═93e6ea83-9091-4a63-8621-6280dd536da5
# ╟─cba784f9-f45d-46f6-aca3-07d20c812a97
# ╟─08dfa6a5-389c-4077-b075-2e955c4e57c2
# ╠═a1d8392d-413a-458d-ab04-7f43b77c8e6a
# ╟─bcd73f54-ef2c-466e-9c0f-d984b95d15a9
# ╠═db5b5c72-9287-459c-b847-d4c7b221c013
# ╟─0c3a4e35-8379-44b7-87dd-164635ee4762
# ╟─f7f2acab-7ec9-42c5-a748-57017d38ac2c
# ╟─0ae3325e-7401-4dbe-90de-f397dd2ac9c2
# ╟─3937d4ad-a2cb-4a45-8924-c7b8209fcb69
# ╠═3a83d392-a17d-495b-94d6-382cce2721fe
# ╟─3b90445d-fa36-4c71-8c1a-d53446721135
# ╠═4a9bea24-a793-4937-b8ca-3cec0fceefef
# ╟─224d72d0-84f7-44bc-b2df-353af191506b
# ╠═fe6c46ca-839b-4614-a217-a840d91f4781
# ╠═e252f15f-e26c-402c-9f46-92f89cf326a4
# ╟─28ac9689-23da-40f6-bb0e-8d2f19eee1a4
# ╠═f115305e-6a23-48a2-80e0-bd340d158eae
# ╟─57496a51-bf74-41d3-bb6a-f3722c20d27d
# ╠═1ad90c37-3e5b-44a1-a5ac-be25f57ee45e
# ╟─3be14272-fd8b-466b-8c0a-d07024ceeab9
# ╠═1912596b-bfb2-4a3c-aea2-029516593f06
# ╟─7369b33e-fcbb-429c-a4ad-1b25c71f6044
# ╟─7a6c4967-4acb-4026-bbca-abfa079cf829
# ╠═54f6b25a-f8bf-407f-9b2c-b2484bdf312f
# ╟─cf784819-0630-4331-b727-9b4fb959f6f7
# ╠═ea109f29-2d1a-47a9-af04-1fafd156eaaf
# ╟─2428dd13-08bf-4110-9030-48a67da0198d
# ╟─a349ac42-2420-4782-9ebb-1447da8103c5
# ╟─a4bdc1f6-bea0-4d92-b5fa-aef2ee1527f6
# ╟─a0a5a31d-0609-432e-ab48-e4868ed008ee
# ╟─d9c64986-a58b-4f78-96e6-52b68b9884c0
# ╟─829b3c32-ebab-4050-a65b-8868d46a9a3d
# ╠═8c65bd6f-e5a7-4a90-a885-5bdc9f362c3c
# ╟─42025733-5767-4731-82ac-7d3f630d577e
# ╠═b836df7d-986b-47ff-a3ce-ec7756b447f1
# ╟─fe5e6756-c9ee-4b90-89a0-0b3a225ca564
# ╟─28afaa7e-2872-41e7-838a-6a7a12649011
# ╠═4c6c80ba-dd8a-4fdc-8628-83e5e42da94d
# ╟─d73af2f1-0cf0-40f7-be81-05fa181e6aef
# ╟─70be4467-1d05-4ca7-86ed-c682e286dd17
# ╟─81e36320-015e-4a66-aba1-93bbbdcd09d0
# ╠═03509878-4ed5-4bd7-b45d-926edb06ac93
# ╟─5a1b3462-828d-445b-88bc-c7ff8cef6b83
# ╠═c4775141-9fd6-43e1-aa24-d6e07c581d8a
# ╟─23cd24c5-349f-4413-80c8-c381303f49e6
# ╟─2202ff78-13a4-4c3a-a954-29877dc9ae38
# ╟─e52f8a7c-e0d2-4720-ab9e-afe0bdb321f9
# ╠═41c4a7ba-1d08-4c5e-99d3-b1998654a484
# ╟─4719c2c8-ef9b-4ce3-85ae-a4137025e417
# ╟─90ce8f3b-739c-4d18-9bce-4d98d020c71e
# ╟─c929b47a-85ec-4af8-a22c-ef9f8c941c0e
# ╠═a382746c-3e19-4931-abb0-a42ccf66199a
# ╟─5d263939-8529-41fd-bc93-e27db655d927
# ╟─ea1d6d81-8734-4349-8f15-a2d0c6cf3c1e
# ╠═5cb65686-a8af-4d0d-8987-9563169d6f22
# ╟─27d21c5e-5afc-41f0-b6dc-d59e7ba52640
# ╠═b24f35b4-ec41-4591-86a3-dca18076f9c5
# ╟─b13e1b5b-a356-4b10-ad0a-0d2160ac6347
# ╟─b8e2e3b5-6aee-4e0d-93ef-fbb7a3723390
# ╟─237c1840-615b-4764-8b3f-8692f5471f60
# ╠═fdf0bbf2-3ac7-42b9-81ac-f337acfa41c6
# ╟─c63e2b9f-4ec9-468a-821a-22323924f683
# ╠═afc6bb3e-fae9-4d7f-99a5-f4d51ec2912b
# ╟─4350794e-7ae4-4ae5-a0cb-8f1d3aeaf8bd
# ╟─82ca80f9-1fbe-41f2-bfe5-9f29df5ee6ce
# ╟─6eb75df2-afa7-490a-b659-992997fff79e
# ╟─2afc3762-6968-4282-b0f6-93c5b41f5e01
# ╟─47473dd9-a17d-4ea8-84c5-5b83dd3cd093
# ╠═c0f0be86-1368-4c11-8b2b-83f52d2de26c
# ╠═26368893-3759-4a5d-825f-54698d7ded34
# ╟─5dc0939e-9df7-4aed-870a-53c1f84c2c07
# ╠═b852401f-b919-42c6-a3ea-bf8861b84633
# ╟─3127486a-f4c9-41bc-a42e-12cdd3c7d24d
# ╟─57956a81-c59d-4aea-9996-44c9848737a5
# ╟─3d1ab831-cce8-4f23-b855-6c9cf3dfa73b
# ╠═b1049b3b-cbfd-4a59-9fe5-38fe0d1d267d
# ╠═f8d8e0f7-dfd7-47fa-bccd-51f18196f37d
# ╟─ca1645e9-73b2-4ff3-a6bc-689109534143
# ╠═15dc95fb-0b4b-47a8-be1d-2004517632f9
# ╠═33a3fdc6-501c-4d68-b03e-1ac5b0a2266d
# ╠═98e1e750-18fc-4ca7-b59d-cce73640e5ea
# ╟─b7d302af-0316-4601-bde8-b992008c9c38
# ╠═4d280ca2-0b96-4ddf-a647-8dcd7be467e7
# ╠═4aa82ae6-b14d-41bb-8c6a-59ca8a4e4554
# ╟─b7740b44-c211-45a1-97fa-a636a40e74ea
# ╟─19859f6a-534e-43f1-9b0d-538c096c5895
# ╠═2b61d937-6f3f-41e4-9a68-e93d1785fbdf
# ╟─a9c9e5c7-d931-42a7-9e01-ac72e56f41b4
# ╠═03b1d04a-74ed-4553-afdd-075f6e484fb8
# ╟─8cd50a46-25b4-4d95-bea4-3f76de93140d
# ╠═7b5ee0ca-7add-4148-9ae4-f596a4103dea
# ╟─b0393d09-cc82-4993-8afb-e8f491de6315
# ╟─645eef54-d10f-4643-a67b-b0fdd6c9a9ad
# ╠═cf06164f-2eda-4de2-8c6e-da92c53eb642
# ╟─8c72ce13-a9bd-4f00-b88a-d930709852cc
# ╠═e4e24951-3d16-49fb-94a0-66737e7e6c9a
# ╟─3df8d99b-e5d8-46fa-a7f1-eeecf182c001
# ╟─9305650a-1c19-4f18-9eb7-2859ec8a8dd3
# ╟─91f1dfe4-8f8f-42f4-8fdf-8c30dfd1baa2
# ╟─3d760d90-72b3-4ddf-b496-b763ab488ad5
# ╟─8865b9c2-c4f1-4dea-a6f0-c8fe6e6f3dee
# ╟─dca999da-ada3-4f63-a308-c6b38b5a1ca3
# ╟─c52734da-cd52-4f8f-955f-06e117a4727b
# ╟─5ad02271-131a-49fd-9d52-39bc3bbfedcb
# ╟─407d4062-fc15-4e64-99b7-60e831aae9c2
# ╟─9746dbf2-b097-46e4-849e-7aa2a0c455c8
# ╟─03ccbc29-d9c4-41e8-a00e-dc5e2019aca1
# ╟─7e311587-d1f7-4187-a058-459d038373d5
# ╠═5f78d45b-e363-48e6-a18e-32d32dcb83fd
# ╟─94e869eb-31b2-4a7d-be18-1554f0a0e124
# ╟─999fe0b9-db6c-43c0-aca7-e4b9f2f0f3a2
# ╠═fa03a2f5-b409-4bd4-9218-035b09d75eb6
# ╟─0ab18e0c-53dc-4b52-b454-ce3050c6ec10
# ╟─a1def259-1884-4f89-911e-84a09775da5f
# ╠═0b85d252-39fe-45dc-a030-214960be4222
# ╟─f44536c9-ec2c-4157-97be-b4b100a6ebf5
# ╟─6f46c577-0cfd-4819-a319-7307570e10e8
# ╠═3b364fe7-0a4a-460b-98c1-562692c2942d
# ╟─5d577361-ded4-497c-b8e0-e9cdf36e41cb
# ╟─b7e98a7a-be01-48be-9412-55f27cb9dbfe
# ╠═32fdd686-8919-4a82-acfb-58bd7ccbdce2
# ╟─fa477807-1aa4-4684-929c-cc71c0558380
# ╟─874ac0c3-1230-413f-bf35-09c99f558c58
# ╟─c897a0d7-ae08-4de4-9fd2-c6f055a00c28
# ╟─a1cb63a8-cfe8-468a-9d9a-dfefe017f857
# ╠═7d136d97-6a6e-40d6-8944-434f3b225e85
# ╟─3af702f0-875e-46df-97c4-e0654c542669
# ╠═781be443-d4b0-48fa-b073-5549510a9dc3
# ╟─0687506b-b8d3-4432-bb0f-c6e59381f180
# ╠═40af53c9-f4fc-480d-8a6e-7508efa19dba
# ╟─887f528c-f22c-48de-a741-fb82b8891570
# ╟─81a1029a-ee2c-4420-ba98-156b8a1b7df0
# ╠═366c198c-277e-4848-8028-b46d4a99a011
# ╟─4c1a7612-035e-46b1-baea-02fc7acb578a
# ╟─c83a85a4-59e8-4b1a-b9e1-fc396f51d2df
# ╠═a22f98ad-2e70-4445-9101-533ae50c3ade
# ╟─5562d28e-b991-42ad-8d2a-9119d3e08361
# ╟─d0e5e8ea-88a5-4e28-8edc-1ac862490e34
# ╠═fca358b5-de42-434a-a5c1-0d2ef7d01f15
# ╟─5fbbadad-5420-481c-867b-9a3cd976d928
# ╠═95a12a45-01d9-4116-940c-ccbb4e7c5136
# ╟─0ca8aecb-4e4c-4b8d-86f4-8f508683f462
# ╠═6588604b-8271-47b4-98d2-112f7c73a39a
# ╟─b959cc7f-58f6-4f68-8bfb-c93b0bdcc798
# ╟─9a81ac7f-eccf-4344-a006-5800132facc9
# ╟─f742793f-e965-453c-8912-4feb5ffdf387
# ╟─d39ab0ee-8efa-417b-8756-79d3dbe0d81b
# ╠═6ab8efde-7923-430e-9821-2f42c8e60c1b
# ╟─100ee448-ee6f-4cff-93cb-daed4716907e
# ╠═87ccd5d9-9650-4e0f-afe4-c4b2fa259f6d
# ╟─dbcf460c-4f91-4a53-895a-e5f3ad723e33
# ╟─8a9844b2-a23e-4414-a647-bfe38dfbdf7f
# ╟─4ed8a76d-44b2-4893-b923-60c9117b8488
# ╠═6cf110d0-05ae-4615-a9bf-673df472772b
# ╟─ac726940-3990-466d-989a-f5875081b438
# ╟─9ba32774-a4b1-41b1-bbd2-538684e7a11e
# ╠═96c27d74-03c4-42f6-be0f-a78003cf0b27
# ╠═37417c86-cf2f-438e-8dab-2f8be3b7c74d
# ╠═7b79d383-de1e-4790-af17-6843a21e11fa
# ╠═a9eeac32-cda5-4d9c-a41c-ad7bcdda53aa
# ╟─e6334309-ed59-4035-927f-efccbde55c1d
# ╠═9844167d-11cf-4b8f-b8a3-a4fc9c7edac2
# ╟─2479956b-b158-4205-8fa4-a25a305d04a6
