def calc_fuel(module_mass):
    return (module_mass // 3) - 2

def fuel_for_fuel(fuel):
    total = 0
    while (fuel > 0):
        fuel = calc_fuel(fuel)
        print(fuel)
        total += fuel
    total -= fuel

    return total

if __name__ == '__main__':
    with open('in') as f:
        mass_per_module = map(int, f)
        fuel_per_modules = [calc_fuel(mass) for mass in mass_per_module]
        extra_fuel_per_module = [fuel_for_fuel(module_fuel) for module_fuel in fuel_per_modules]
        total_fuel = sum(fuel_per_modules) + sum(extra_fuel_per_module)
        print('total fuel:', total_fuel)
