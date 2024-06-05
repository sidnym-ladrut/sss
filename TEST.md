# VSSS Testing

`vsss` (or "versioned `sss`") is a version of `sss` developed by
`~midlev-mindyr` in order to improve the robustness of solid-state
subscriptions across upgrade boundaries.

This branch demonstrates how this version of the library performs under
different upgrade circumstances, and (in combination with `sl/test-vsss`) how
to seamlessly upgrade from `sss` to `vsss`.

## Test Case

The test case we use to demonstrate the different upgrade behaviors broadly
has the following steps:

1. Deploy an SSS-enabled agent on two ships.
2. Set up a publisher ship and a subscriber ship.
3. Upgrade one of the ships to a new SSS model.
4. Push an update on the publisher.
5. Upgrade the other ship to the same new SSS model.
6. Push another update on the publisher.

When running with [durploy], this translates to the following commands:

```bash
# step 1
durploy ship simp-zod
durploy ship simp-nec
cd /path/to/sss
git checkout [reference-branch-here]
durploy desk -r always simp-zod simple ./urbit/
durploy desk -r always simp-nec simple ./urbit/

# step 2
~zod> :simple &add 1
~nec> :simple &surf-sum [~zod %sum %foo ~]

# step 3 (update publisher)
git checkout sl/demo-vsss
durploy desk -r never simp-zod simple ./urbit/

# step 4
~zod> :simple &add 1

# step 5 (update subscriber)
durploy desk -r never simp-nec simple ./urbit/

# step 6
~zod> :simple &add 1
```

This test case is run with three variants to fully exercise all of the
potential upgrade paths:

1. **Lockstep**: The publisher and subscriber upgrade in lockstep (i.e. omit
   step 4).
2. **Publisher First**: The publisher upgrades before the subscriber (i.e.
   upgrade the publisher in step 3 and the subscriber in step 5).
3. **Subscriber First**: The subscriber upgrades before the publisher (i.e.
   upgrade the subscriber in step 3 and the publisher in step 5).

### SSS-to-VSSS Results

When performing an upgrade from an unversioned `sss` agent to a versioned one
(use the reference branch `sl/demo-usss`), the test case variants yield the
following results:

1. **Lockstep**: No interruption
2. **Publisher First**: Publisher drops the connection after the first update
   (due to poke failure); the subscriber is not notified of this failure (!)
   and must manually resubscribe to receive updates
3. **Subscriber First**: Subscriber marks its connection as `fail` on the first
   update, then unsubscribes on any subsequent update

### VSSS-to-VSSS Results

When performing an upgrade between different versioned `sss` agents (use the
reference branch `sl/demo-osss`), the test case variants yield the following
results:

1. **Lockstep**: No interruption
2. **Publisher First**: Subscriber marks its connection as `fail` on the first
   update, then unsubscribes on any subsequent update
3. **Subscriber First**: No interruption (subscriber continues to receive
   updates as normal until the publisher upgrades)


[durploy]: https://github.com/sidnym-ladrut/durploy
