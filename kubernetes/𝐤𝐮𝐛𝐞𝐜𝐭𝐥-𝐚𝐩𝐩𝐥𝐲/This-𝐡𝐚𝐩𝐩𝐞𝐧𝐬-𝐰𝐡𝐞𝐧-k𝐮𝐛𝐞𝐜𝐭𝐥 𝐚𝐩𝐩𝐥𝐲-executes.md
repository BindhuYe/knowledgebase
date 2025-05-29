Here’s what really happens when you 𝐚𝐩𝐩𝐥𝐲 that 𝐦𝐚𝐧𝐢𝐟𝐞𝐬𝐭:

1️⃣ Your manifest is sent to the 𝐤𝐮𝐛𝐞-𝐚𝐩𝐢𝐬𝐞𝐫𝐯𝐞𝐫, the gatekeeper of the cluster.

2️⃣ The API server stores the desired state in 𝐞𝐭𝐜𝐝, the cluster’s source of truth.

3️⃣ 𝐀𝐝𝐦𝐢𝐬𝐬𝐢𝐨𝐧 𝐂𝐨𝐧𝐭𝐫𝐨𝐥𝐥𝐞𝐫𝐬 kick in, validating and mutating your resource if needed. (e.g. injecting sidecars, enforcing policies, rejecting unlabelled pods, etc.)

4️⃣ 𝐓𝐡𝐞 𝐒𝐜𝐡𝐞𝐝𝐮𝐥𝐞𝐫 sees the new pod spec and finds the best node to place it on, based on things like resource requests, affinity rules, taints and tolerations, etc.

5️⃣ Once scheduled, the 𝐤𝐮𝐛𝐞𝐥𝐞𝐭 on that target node pulls the container image (if not cached), creates the pod, and starts it up using 𝐜𝐨𝐧𝐭𝐚𝐢𝐧𝐞𝐫𝐝 or 𝐂𝐑𝐈-𝐎.

6️⃣ Meanwhile, 𝐜𝐨𝐧𝐭𝐫𝐨𝐥𝐥𝐞𝐫𝐬 like the ReplicaSet controller or Deployment controller ensure your declared state is always met.

7️⃣ Liveness/readiness probes, service endpoints, DNS, networking, CNI plugins, all kick into gear to wire up your pod properly in the cluster.
