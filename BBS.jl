using Primes

function BBS(p::BigInt, q::BigInt, seed::BigInt, num_bits::Int64)
    """
    Generates a sequence of random bits using the Blum Blum Shub (BBS) algorithm.

    Args:
        p::BigInt: A large safe prime number such that p ≡ 3 (mod 4).
        q::BigInt: A large safe prime number distinct from p such that q ≡ 3 (mod 4).
        seed::BigInt: An initial seed value (x₀), relatively prime to n = p*q.
        num_bits::Integer: The number of random bits to generate.

    Returns:
        BitVector: A BitVector containing the generated random bits.

    Raises:
        Error: If input parameters are invalid .
    """

    # 1. Input Validation
    if p % 4 != 3 || q % 4 != 3
        error("p and q must be congruent to 3 modulo 4.")
    end
    
    if !isprime(p) || !isprime(q) || !isprime((p-1) ÷ 2) || !isprime((q-1) ÷ 2)
        error("p,q,(p-1)/2,(q-1)/2 must be prime numbers.")
    end

    n = p * q

    if gcd(seed, n) != 1
        error("Seed must be relatively prime to n = p*q.")
    end
    if seed <= 0
        error("Seed must be a positive integer.")
    end
    if num_bits <= 0
        error("num_bits must be a positive integer.")
    end

    # 2. Initialize State
    x = seed
    bits = BitVector(undef, num_bits) # Efficiently store bits

    # 3. BBS Iteration and Bit Extraction
    for i in 1:num_bits
        x = (x * x) % n  # BBS state update: x_{i+1} = x_i^2 mod n
        bits[i] = x % 2 == 1 # Extract the least significant bit (LSB) as the random bit
    end

    return bits
end

# Example Usage:
# Choose large primes p and q congruent to 3 mod 4.
# These are just examples, for security you'd use much larger p
p = BigInt(1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001408267)
# q is the smallest safe prime after 1000^102
q = BigInt(1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000933859)

# Choose a seed relatively prime to n = p*q
# seed ≈ 2 * 1000^102
seed = BigInt(2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000420063)
num_bits = 10 # Number of random bits to generate

random_bits = BBS(p, q, seed, num_bits)

println("GCD of (p-3)/2, (q-3)/2) is : ", gcd(((p-3) ÷ 2), (q-3) ÷ 2))
println("Generated BBS Random Bits:", random_bits)

# You can convert the BitVector to other formats if needed. example with an array of 0s and 1s:
random_bit_array = Int.(random_bits)
println("As an Array of Integers (0 and 1):",random_bit_array)

# To get a random number from these bits, you could interpret them as a binary number.
# For example,
function bits_to_int(bit_vector::BitVector)
    value = BigInt(0)
    power_of_2 = BigInt(1)
    for bit in reverse(bit_vector) # Process from least significant to most significant
        if bit
            value += power_of_2
        end
        power_of_2 *= 2
    end
    return value
end

random_integer = bits_to_int(random_bits)

println("As a Random Integer: " ,random_integer)